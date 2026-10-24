#!/usr/bin/env bash
# Remove HEV Suit system-sound wiring (dispatcher + hev-sound hooks).
# Does not remove Lock Sound, the theme, or sounds/*.ogg — only the wiring.
set -euo pipefail

note() { printf 'hev-suit sounds: %s\n' "$*"; }
removed=0

rm_if() {
  local path=$1
  if [[ -e $path || -L $path ]]; then
    rm -f "$path"
    note "removed $path"
    removed=1
  fi
}

rm_if "$HOME/.local/bin/omarchy-sound"
rm_if "$HOME/.config/omarchy/hooks/post-boot.d/hev-sound.hook"
rm_if "$HOME/.config/omarchy/hooks/battery-low.d/hev-sound.hook"
rm_if "$HOME/.config/omarchy/hooks/post-update.d/hev-sound.hook"
rm_if "${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/hev-update-sound.log"

if (( removed == 0 )); then
  note "nothing to remove (wiring already gone)"
else
  note "done — theme sounds stay on disk; other themes stay quiet without the hooks"
  note "optional: omarchy plugin remove io.github.alxwolfenstein97.lock-sound --yes"
fi
