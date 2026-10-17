import { fileURLToPath } from "node:url";
import discourse from "@discourse/lint-configs/eslint";

// The pinned upstream config strips file:// from its Babel plugin URL. On
// Windows that leaves an encoded /C:/ path, which Babel cannot resolve.
export default discourse.map((entry) => {
  const babel = entry.languageOptions?.parserOptions?.babelOptions;
  if (process.platform !== "win32" || !babel?.plugins) {
    return entry;
  }

  return {
    ...entry,
    languageOptions: {
      ...entry.languageOptions,
      parserOptions: {
        ...entry.languageOptions.parserOptions,
        babelOptions: {
          ...babel,
          plugins: babel.plugins.map((plugin) =>
            Array.isArray(plugin) && /^\/[A-Za-z]:\//.test(plugin[0])
              ? [fileURLToPath(`file://${plugin[0]}`), ...plugin.slice(1)]
              : plugin
          ),
        },
      },
    },
  };
});
