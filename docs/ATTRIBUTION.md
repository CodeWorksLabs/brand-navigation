# Attribution and source accounting

Brand Navigation is an independent implementation inspired by:

- [Discourse Brand Header](https://github.com/discourse/discourse-brand-header)
  — brand identity, top-level links, outlet placement, and mobile presentation.
- [Discourse Header Submenus](https://github.com/discourse/discourse-header-submenus)
  — a site-global bar with parent and child navigation.

Both predecessor repositories are distributed under the MIT License. Their
license notices remain in their respective repositories.

## Copied or adapted code

No runtime source code, styles, migrations, tests, or documentation were copied
or adapted from either predecessor in this initial implementation.

The implementation uses standard Discourse patterns also present throughout
the ecosystem: `withPluginApi`, `api.renderInOutlet`, Glimmer `.gjs`
components, theme settings, `LightDarkImg`, `DMenu`, Font Awesome helpers, and
system-test scaffolding. Use of these framework conventions is independent and
does not constitute copying predecessor code.

Tooling versions and conventional configuration shapes were selected against
the current official repositories. If future changes copy or adapt predecessor
code, update this file with the source repository, commit, file, relevant
license, and nature of the adaptation before release.
