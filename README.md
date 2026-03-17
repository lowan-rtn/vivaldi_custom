# vivaldi_custom

Bundle de personnalisation Vivaldi pour réappliquer :
- l'icône Safari-like
- le CSS custom Vivaldi
- le lanceur `.desktop`

## Structure

- `package/vivaldi-css/` : mods CSS à injecter dans Vivaldi
- `package/applications/` : overrides `.desktop`
- `package/icons/` : icônes locales
- `scripts/install-local.sh` : installe le bundle dans `~/.config` et `~/.local/share`
- `scripts/build-tarball.sh` : fabrique une archive distribuable

## Installation locale

```sh
./scripts/install-local.sh
```

Puis dans Vivaldi :
- active `Allow CSS Modifications` dans `vivaldi:flags`
- dans `Settings > Appearance > Custom UI Modifications`, pointe vers :
  `~/.config/vivaldi-css`

## Archive

```sh
./scripts/build-tarball.sh
```
