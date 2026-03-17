# vivaldi_custom

Bundle de personnalisation Vivaldi pour réappliquer :
- l'icône Safari-like
- le CSS custom Vivaldi
- le lanceur `.desktop`
- un paquet Debian installable

## Structure

- `package/vivaldi-css/` : mods CSS à injecter dans Vivaldi
- `package/applications/` : overrides `.desktop`
- `package/icons/` : icônes locales
- `scripts/install-local.sh` : installe le bundle dans `~/.config` et `~/.local/share`
- `scripts/build-tarball.sh` : fabrique une archive distribuable
- `scripts/build-deb.sh` : fabrique un vrai `.deb`
- `scripts/vivaldi-custom-apply.sh` : applique le bundle à un utilisateur

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

## Paquet Debian

```sh
./scripts/build-deb.sh
```

Le paquet sera créé dans `dist/`.

### Fonctionne si Vivaldi n'est pas encore installé ?

Oui.

Le paquet :
- s'installe même sans `vivaldi-stable`
- pose les fichiers système et `/etc/skel`
- tente d'appliquer le bundle aux utilisateurs existants

Ensuite, dès que `vivaldi-stable` est installé, il suffit de lancer :

```sh
sudo vivaldi-custom-apply <utilisateur>
```
