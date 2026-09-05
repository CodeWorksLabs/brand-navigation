#!/usr/bin/env node

import { readFile, writeFile } from "node:fs/promises";
import process from "node:process";
import { pathToFileURL } from "node:url";

import {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  createBundle,
  PORTABLE_SETTINGS,
  themeSettingValue,
  validateBundle,
} from "../javascripts/discourse/lib/configuration-bundle.js";

export {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  createBundle,
  themeSettingValue,
  validateBundle,
};

export function normalizeSettingValue(name, value) {
  if (name === "navigation_items") {
    return JSON.stringify(value);
  }

  if (name === "custom_font_awesome_icons") {
    return value.join("|");
  }

  return value;
}

function parseArguments(argv) {
  const [command, file, ...rest] = argv;
  const options = {};

  for (let index = 0; index < rest.length; index += 2) {
    options[rest[index]] = rest[index + 1];
  }

  return { command, file, options };
}

async function readBundle(file) {
  const bundle = JSON.parse(await readFile(file, "utf8"));
  const errors = validateBundle(bundle);

  if (errors.length) {
    throw new Error(errors.join("\n"));
  }

  return bundle;
}

function apiOptions(options) {
  const baseUrl = options["--url"]?.replace(/\/$/, "");
  const themeId = options["--theme-id"];
  const apiKey = process.env.DISCOURSE_API_KEY;
  const apiUsername = process.env.DISCOURSE_API_USERNAME;

  if (!baseUrl || !themeId) {
    throw new Error("--url and --theme-id are required.");
  }

  if (!apiKey || !apiUsername) {
    throw new Error(
      "DISCOURSE_API_KEY and DISCOURSE_API_USERNAME are required."
    );
  }

  return { baseUrl, themeId, apiKey, apiUsername };
}

function headers({ apiKey, apiUsername }) {
  return {
    Accept: "application/json",
    "Api-Key": apiKey,
    "Api-Username": apiUsername,
    "Content-Type": "application/json",
  };
}

async function applyBundle(file, options) {
  const bundle = await readBundle(file);
  const api = apiOptions(options);
  const target = await fetchTheme(api);
  const targetSettings = settingsFromTheme(target);

  for (const name of Object.keys(bundle.settings)) {
    if (!(name in targetSettings)) {
      throw new Error(
        `Target theme ${api.themeId} does not define setting ${name}.`
      );
    }
  }

  const settings = Object.fromEntries(
    Object.entries(bundle.settings).map(([name, value]) => [
      name,
      normalizeSettingValue(name, value),
    ])
  );
  const response = await fetch(
    `${api.baseUrl}/admin/themes/${api.themeId}.json`,
    {
      method: "PUT",
      headers: headers(api),
      body: JSON.stringify({ theme: { settings } }),
    }
  );

  if (!response.ok) {
    throw new Error(
      `Import failed: ${response.status} ${await response.text()}`
    );
  }

  process.stdout.write(
    `Updated ${Object.keys(settings).length} settings on theme ${api.themeId}\n`
  );
}

function settingsFromTheme(theme) {
  if (Array.isArray(theme.settings)) {
    return Object.fromEntries(
      theme.settings.map((setting) => [setting.name, setting.value])
    );
  }

  return theme.settings || {};
}

async function exportBundle(file, options) {
  const api = apiOptions(options);
  const theme = await fetchTheme(api);
  const bundle = createBundle(settingsFromTheme(theme), {
    exported_at: new Date().toISOString(),
    source_theme_id: Number(api.themeId),
    source_theme_name: theme.name,
  });

  await writeFile(file, `${JSON.stringify(bundle, null, 2)}\n`, "utf8");
  process.stdout.write(`Exported ${file}\n`);
}

async function fetchTheme(api) {
  const response = await fetch(
    `${api.baseUrl}/admin/themes/${api.themeId}.json`,
    {
      headers: headers(api),
    }
  );

  if (!response.ok) {
    throw new Error(
      `Unable to read target theme: ${response.status} ${await response.text()}`
    );
  }

  const payload = await response.json();
  return payload.theme || payload;
}

function usage() {
  return `Usage:
  pnpm bundle validate <bundle.json>
  pnpm bundle apply <bundle.json> --url <forum-url> --theme-id <id>
  pnpm bundle export <bundle.json> --url <forum-url> --theme-id <id>

apply/export read DISCOURSE_API_KEY and DISCOURSE_API_USERNAME from the
environment. Import updates settings only; it never attaches or enables a
component.`;
}

async function main() {
  const { command, file, options } = parseArguments(process.argv.slice(2));

  if (!command || !file) {
    throw new Error(usage());
  }

  if (command === "validate") {
    await readBundle(file);
    process.stdout.write(`Valid ${BUNDLE_FORMAT} v${BUNDLE_VERSION} bundle\n`);
    return;
  }

  if (command === "apply") {
    await applyBundle(file, options);
    return;
  }

  if (command === "export") {
    await exportBundle(file, options);
    return;
  }

  throw new Error(usage());
}

if (
  process.argv[1] &&
  import.meta.url === pathToFileURL(process.argv[1]).href
) {
  main().catch((error) => {
    process.stderr.write(`${error.message}\n`);
    process.exitCode = 1;
  });
}
