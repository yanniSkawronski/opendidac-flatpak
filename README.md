# OpenDidac Desktop — Flatpak

Empaquette le paquet `.deb` officiel `opendidac-desktop_1.0.0_amd64.deb` (application Electron 39, HEIG-VD) dans le Flatpak `ch.heigvd.opendidac.Desktop`, basé sur le runtime `org.freedesktop.Platform//25.08`.

## Fichiers source

Ce dépôt contient tous les fichiers source nécessaires pour construire le Flatpak soi-même :

- `ch.heigvd.opendidac.Desktop.yml` — manifeste flatpak-builder ; dépaquette le `.deb` au moment du build (`ar` + `zstd`, fournis par le SDK) et mappe `usr/` vers `/app/`
- `opendidac-desktop.sh` — lanceur installé comme `/app/bin/opendidac-desktop` ; ajoute `--no-sandbox` car le sandbox setuid de Chrome ne peut pas tourner dans bwrap
- `ch.heigvd.opendidac.Desktop.desktop` — entrée de bureau (renommée d'après l'ID de l'app, `Exec` corrigé, gestionnaire de schéma `x-scheme-handler/opendidac` conservé)
- `ch.heigvd.opendidac.Desktop.metainfo.xml` — métadonnées AppStream

Le `.deb` n'est **pas** dans le dépôt (voir `.gitignore`) : il se télécharge à l'étape 1 ci-dessous.

Notes :
- L'icône PNG 1024×1024 est réduite à un vrai 512×512 avec `ffmpeg` (présent dans le SDK), car `flatpak-validate-icon` et `appstreamcli compose` rejettent les icônes de plus de 512 px.
- finish-args : sockets x11/wayland/pulseaudio, ipc, réseau, `--device=dri`, xdg-download, notifications, keyring (`org.freedesktop.secrets`) et accès aux portails.

## Prérequis

1. Ajouter le dépôt Flathub (une seule fois ; il fournit le runtime, le SDK et flatpak-builder) :

   ```sh
   flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
   ```

2. Installer les outils de build et le runtime/SDK utilisés par le manifeste :

   ```sh
   flatpak install flathub -y flatpak-builder
   flatpak install flathub -y org.freedesktop.Platform//25.08 org.freedesktop.Sdk//25.08
   ```

## Build

1. **Télécharger le `.deb`** depuis la [page téléchargements](https://opendidac.heig-vd.in/downloads) de Opendidac

2. Construire le Flatpak :

   ```sh
   flatpak-builder --user --force-clean --repo=repo build ch.heigvd.opendidac.Desktop.yml
   ```

## Installer et lancer

```sh
flatpak --user remote-add --no-gpg-verify opendidac-local ./repo
flatpak --user install -y opendidac-local ch.heigvd.opendidac.Desktop
flatpak run ch.heigvd.opendidac.Desktop           # GUI
flatpak run ch.heigvd.opendidac.Desktop --version # test rapide
```

Pour produire un bundle en un seul fichier au lieu d'un dépôt local :

```sh
flatpak build-bundle repo opendidac-desktop.flatpak ch.heigvd.opendidac.Desktop stable
```
