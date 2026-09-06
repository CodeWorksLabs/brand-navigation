#!/usr/bin/env node

import { readFile, stat, writeFile } from "node:fs/promises";
import process from "node:process";
import { pathToFileURL } from "node:url";

import {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  createBundle,
  MAX_BUNDLE_BYTES,
  themeSettingValue,
  validateBundle,
} from "../javascripts/discourse/lib/configuration-bundle.js";

const MAX_API_RESPONSE_BYTES = 1_000_000;
const REQUEST_TIMEOUT_MS = 15_000;

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

export function parseArguments(argv) {
  const [command, file, ...rest] = argv;
  const options = {};

  for (let index = 0; index < rest.length; index += 1) {
    const option = rest[index];

    if (option === "--overwrite") {
      options[option] = true;
      continue;
    }

    if (!option?.startsWith("--") || index + 1 >= rest.length) {
      throw new Error(`Invalid option ${JSON.stringify(option)}.`);
    }

    options[option] = rest[index + 1];
    index += 1;
  }

  return { command, file, options };
}

async function readBundle(file) {
  const fileStats = await stat(file);

  if (fileStats.size > MAX_BUNDLE_BYTES) {
    throw new Error(
      `Bundle cannot exceed ${MAX_BUNDLE_BYTES.toLocaleString()} bytes.`
    );
  }

  const bundle = JSON.parse(await readFile(file, "utf8"));
  const errors = validateBundle(bundle);

  if (errors.length) {
    throw new Error(errors.join("\n"));
  }

  return bundle;
}

export function apiOptions(options, environment = process.env) {
  const rawUrl = options["--url"];
  const rawThemeId = options["--theme-id"];
  const apiKey = environment.DISCOURSE_API_KEY;
  const apiUsername = environment.DISCOURSE_API_USERNAME;

  if (!rawUrl || !rawThemeId) {
    throw new Error("--url and --theme-id are required.");
  }

  if (rawUrl.trim() !== rawUrl) {
    throw new Error("--url must be a canonical HTTPS forum origin.");
  }

  let url;
  try {
    url = new URL(rawUrl);
  } catch {
    throw new Error("--url must be a valid HTTPS forum origin.");
  }

  if (
    url.protocol !== "https:" ||
    url.username ||
    url.password ||
    (url.pathname !== "/" && url.pathname !== "") ||
    url.search ||
    url.hash
  ) {
    throw new Error(
      "--url must be an HTTPS origin without credentials, path, query, or fragment."
    );
  }

  if (!/^[1-9]\d*$/.test(rawThemeId)) {
    throw new Error("--theme-id must be a positive integer.");
  }

  if (!apiKey || !apiUsername) {
    throw new Error(
      "DISCOURSE_API_KEY and DISCOURSE_API_USERNAME are required."
    );
  }

  return {
    baseUrl: url.origin,
    themeId: rawThemeId,
    apiKey,
    apiUsername,
  };
}

function headers({ apiKey, apiUsername }) {
  return {
    Accept: "application/json",
    "Api-Key": apiKey,
    "Api-Username": apiUsername,
    "Content-Type": "application/json",
  };
}

export async function fetchApi(
  api,
  path,
  {
    method = "GET",
    body,
    fetchImpl = fetch,
    timeoutMs = REQUEST_TIMEOUT_MS,
  } = {}
) {
  const response = await fetchImpl(`${api.baseUrl}${path}`, {
    method,
    headers: headers(api),
    body,
    redirect: "error",
    signal: AbortSignal.timeout(timeoutMs),
  });
  const text = await readBoundedText(response);

  if (!response.ok) {
    throw new Error(
      `Discourse request failed: ${response.status} ${sanitizeRemoteText(text)}`
    );
  }

  return text;
}

export async function readBoundedText(
  response,
  maxBytes = MAX_API_RESPONSE_BYTES
) {
  const contentLength = Number(response.headers?.get?.("content-length"));

  if (Number.isFinite(contentLength) && contentLength > maxBytes) {
    await response.body?.cancel?.();
    throw new Error(`Discourse response exceeds ${maxBytes} bytes.`);
  }

  if (!response.body?.getReader) {
    const text = await response.text();

    if (Buffer.byteLength(text, "utf8") > maxBytes) {
      throw new Error(`Discourse response exceeds ${maxBytes} bytes.`);
    }

    return text;
  }

  const reader = response.body.getReader();
  const decoder = new TextDecoder();
  let total = 0;
  let text = "";

  try {
    while (true) {
      const { done, value } = await reader.read();

      if (done) {
        break;
      }

      total += value.byteLength;
      if (total > maxBytes) {
        await reader.cancel();
        throw new Error(`Discourse response exceeds ${maxBytes} bytes.`);
      }

      text += decoder.decode(value, { stream: true });
    }

    return text + decoder.decode();
  } finally {
    reader.releaseLock();
  }
}

export function sanitizeRemoteText(value) {
  return String(value)
    .replace(/[\u0000-\u001f\u007f-\u009f]/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 2_000);
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

  await fetchApi(api, `/admin/themes/${api.themeId}.json`, {
    method: "PUT",
    body: JSON.stringify({ theme: { settings } }),
  });

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

  await writeExportFile(
    file,
    `${JSON.stringify(bundle, null, 2)}\n`,
    options["--overwrite"]
  );
  process.stdout.write(`Exported ${file}\n`);
}

export async function writeExportFile(file, contents, overwrite = false) {
  await writeFile(file, contents, {
    encoding: "utf8",
    flag: overwrite ? "w" : "wx",
  });
}

async function fetchTheme(api) {
  const text = await fetchApi(api, `/admin/themes/${api.themeId}.json`);
  let payload;

  try {
    payload = JSON.parse(text);
  } catch {
    throw new Error("Discourse returned invalid JSON.");
  }

  return payload.theme || payload;
}

function usage() {
  return `Usage:
  pnpm bundle validate <bundle.json>
  pnpm bundle apply <bundle.json> --url <forum-origin> --theme-id <id>
  pnpm bundle export <bundle.json> --url <forum-origin> --theme-id <id> [--overwrite]

apply/export require a canonical HTTPS forum origin and read DISCOURSE_API_KEY
and DISCOURSE_API_USERNAME from the environment. Import updates settings only;
it never attaches or enables a component.`;
}

async function main() {
  const { command, file, options } = parseArguments(process.argv.slice(2));

  if (!command || !file) {
    throw new Error(usage());
  }

  const allowedOptions = new Set(
    command === "export"
      ? ["--url", "--theme-id", "--overwrite"]
      : ["--url", "--theme-id"]
  );
  const unknownOption = Object.keys(options).find(
    (option) => !allowedOptions.has(option)
  );
  if (unknownOption) {
    throw new Error(`Unsupported option ${unknownOption}.`);
  }

  if (command === "validate") {
    if (Object.keys(options).length) {
      throw new Error("validate does not accept options.");
    }

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
