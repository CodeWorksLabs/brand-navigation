import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { readdir, readFile } from "node:fs/promises";
import { relative, resolve } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const root = fileURLToPath(new URL("../../", import.meta.url));
const sourceRoots = ["javascripts", "scripts", "test"];

test("configured JavaScript lint checks every source, script and test file", async (t) => {
  const pkg = JSON.parse(
    await readFile(new URL("../../package.json", import.meta.url))
  );
  const [command, ...args] = pkg.scripts["lint:js"].split(" ");
  assert.equal(command, "eslint");
  assert.deepEqual(args, [...sourceRoots, "--max-warnings", "0"]);

  const result = spawnSync(
    process.execPath,
    [
      resolve(root, "node_modules/eslint/bin/eslint.js"),
      ...args,
      "--format",
      "json",
    ],
    {
      cwd: root,
      encoding: "utf8",
      windowsHide: true,
      maxBuffer: 10 * 1024 * 1024,
    }
  );
  assert.ifError(result.error);
  assert.equal(result.signal, null);
  assert.equal(result.status, 0, result.stderr || result.stdout);
  const results = JSON.parse(result.stdout);
  const expected = [];
  for (const directory of sourceRoots) {
    for (const entry of await readdir(resolve(root, directory), {
      recursive: true,
      withFileTypes: true,
    })) {
      if (entry.isFile() && /\.(?:js|gjs|mjs)$/.test(entry.name)) {
        expected.push(
          relative(root, resolve(entry.parentPath, entry.name)).replaceAll(
            "\\",
            "/"
          )
        );
      }
    }
  }
  const actual = results.map(({ filePath }) =>
    relative(root, filePath).replaceAll("\\", "/")
  );
  assert.ok(
    expected.length > 2,
    "coverage must include more than the two integration tests"
  );
  assert.deepEqual(
    actual.sort(),
    expected.sort(),
    "no source files may be silently omitted"
  );
  t.diagnostic(`Verified JavaScript lint coverage: ${actual.length} files`);
});
