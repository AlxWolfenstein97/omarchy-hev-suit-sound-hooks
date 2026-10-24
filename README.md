# HEV Suit sound hooks

Optional desktop wiring for the
[HEV Suit](https://github.com/AlxWolfenstein97/omarchy-hev-suit-theme) Omarchy
theme: install the theme-agnostic `omarchy-sound` dispatcher and three
`hev-sound` hooks so login / low-battery / post-update play the current theme’s
`sounds/*.ogg` when present.

This repo is **hooks only**. The VO clips live in the theme’s `sounds/` folder.
Omarchy’s theme gallery does not list repositories that ship runnable code
inside a theme pack — so the wiring sits here instead.

## Prerequisites

1. **[HEV Suit theme](https://github.com/AlxWolfenstein97/omarchy-hev-suit-theme)**
   installed and (for the cues to be audible) set as current — the dispatcher
   plays `~/.local/state/omarchy/current/theme/sounds/<name>.ogg`.
2. `paplay` available (PipeWire / Pulse).
3. **Denied (wrong unlock)** still needs
   [Lock Sound](https://github.com/AlxWolfenstein97/omarchy-lock-sound) —
   stock lock has no failure hook. Login / battery / update only need this
   repo’s install script.

## Install

```bash
git clone https://github.com/AlxWolfenstein97/omarchy-hev-suit-sound-hooks.git
cd omarchy-hev-suit-sound-hooks
./install-sounds.sh
```

That installs:

| Path | Role |
|------|------|
| `~/.local/bin/omarchy-sound` | Theme-agnostic player |
| `~/.config/omarchy/hooks/post-boot.d/hev-sound.hook` | Login cue |
| `~/.config/omarchy/hooks/battery-low.d/hev-sound.hook` | Battery cue |
| `~/.config/omarchy/hooks/post-update.d/hev-sound.hook` | Update cue |

Denied (optional):

```bash
omarchy plugin add https://github.com/AlxWolfenstein97/omarchy-lock-sound.git --enable
omarchy-restart-shell
```

Smoke-test: `omarchy-sound login` / `battery` / `update` / `denied`.

## Tear down

```bash
./uninstall-sounds.sh
# optional — remove Lock Sound too:
omarchy plugin remove io.github.alxwolfenstein97.lock-sound --yes
```

Leaves the theme and `sounds/*.ogg` alone; only removes the dispatcher + hooks
(and the optional update-sound debug log).

## Cue map (theme assets)

| Theme file | Line | Trigger |
|------------|------|---------|
| `sounds/login.ogg` | Welcome + vitals OK | Desktop start (`post-boot`) |
| `sounds/battery.ogg` | Vital signs critical | Low battery ≤10%, discharging |
| `sounds/update.ogg` | Power restored | After `omarchy update` finishes (see below) |
| `sounds/denied.ogg` | Biohazard detected | Wrong password via Lock Sound |

VO: **Kerensa “Goth_Lady1987” Hayes**, lite pack chopped by
**Alex_Wolfenstein97** from
[GothLady’s HEV Suit Voice](https://steamcommunity.com/sharedfiles/filedetails/?id=2877289836).
Credit / permission notes live on the theme README.

## How each cue fires

1. **Login** — Hyprland autostart runs `omarchy-hook post-boot` →
   `omarchy-sound login` → current theme’s `sounds/login.ogg` if present.
2. **Battery** — Omarchy’s battery path fires `battery-low` hooks →
   `omarchy-sound battery`.
3. **Update** — stock Omarchy calls `omarchy-hook post-update` mid-pipeline
   (after system packages + migrations, before AUR / mise). The hook captures
   the parent `omarchy-update` PID, then waits until that process exits before
   playing — roughly when the “Done — press any key” prompt shows. Manual
   `omarchy hook post-update` (no update parent) plays immediately. Debug:
   `~/.local/state/omarchy/hev-update-sound.log`.
4. **Denied** — Lock Sound → `omarchy-sound denied`.

The dispatcher is theme-agnostic: switch away from HEV Suit and missing files
are silent (no freedesktop ding). Switch back and the cues return.

Sources under `sound-wiring/` if you want to inspect before installing.

Pattern inspired by
[Shiver-dev01/omarchy-black-mesa-theme](https://github.com/Shiver-dev01/omarchy-black-mesa-theme)
(they document wiring; HEV Suit ships the clips; this repo ships the install).

## License

MIT for the scripts and hooks. The audio stays under the theme’s credit /
permission terms — this repository does not redistribute the `.ogg` files.
