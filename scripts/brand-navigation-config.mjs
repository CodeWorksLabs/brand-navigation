#!/usr/bin/env node

import { readFile, stat } from "node:fs/promises";
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

export {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  createBundle,
  themeSettingValue,
  validateBundle,
};

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

function usage() {
  return `Usage:
  pnpm bundle validate <bundle.json>`;
}

async function main() {
  const [command, file, ...options] = process.argv.slice(2);

  if (command !== "validate" || !file || options.length) {
    throw new Error(usage());
  }

  await readBundle(file);
  process.stdout.write(`Valid ${BUNDLE_FORMAT} v${BUNDLE_VERSION} bundle\n`);
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
