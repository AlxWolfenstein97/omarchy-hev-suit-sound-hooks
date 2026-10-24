#!/usr/bin/env bash
# Install HEV Suit system-sound wiring: omarchy-sound + hev-sound hooks.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$here/sound-wiring"
note() { printf 'hev-suit sounds: %s\n' "$*"; }

[[ -d $src ]] || { echo "missing $src" >&2; exit 1; }

mkdir -p "$HOME/.local/bin"
install -m 755 "$src/omarchy-sound" "$HOME/.local/bin/omarchy-sound"

mkdir -p "$HOME/.config/omarchy/hooks"/{post-boot,battery-low,post-update}.d
install -m 755 "$src/post-boot.hev-sound.hook" \
  "$HOME/.config/omarchy/hooks/post-boot.d/hev-sound.hook"
install -m 755 "$src/battery-low.hev-sound.hook" \
  "$HOME/.config/omarchy/hooks/battery-low.d/hev-sound.hook"
install -m 755 "$src/post-update.hev-sound.hook" \
  "$HOME/.config/omarchy/hooks/post-update.d/hev-sound.hook"

note "installed dispatcher → ~/.local/bin/omarchy-sound"
note "installed hooks → ~/.config/omarchy/hooks/{post-boot,battery-low,post-update}.d/hev-sound.hook"
note "clips come from the current theme’s sounds/ (install HEV Suit + set it):"
note "  https://github.com/AlxWolfenstein97/omarchy-hev-suit-theme"
note "denied cue needs Lock Sound separately:"
note "  omarchy plugin add https://github.com/AlxWolfenstein97/omarchy-lock-sound.git --enable"
note "smoke: omarchy-sound login"
