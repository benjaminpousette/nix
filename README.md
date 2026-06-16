# Ben's NixOS configuration

flake-parts + import-tree, dendritic-style: every file in `modules/` is
auto-imported and contributes its own piece of the flake. No manual imports
list to maintain — add a file, it's picked up.

## Structure

- `flake.nix` — just inputs and `import-tree ./modules`.
- `modules/parts.nix` — declares supported systems, pulls in home-manager's
  own flake-parts module.
- `modules/features/` — one file per concern: `common.nix` (shared system
  settings), `home-manager.nix` (wires home-manager into NixOS), `niri.nix`
  (the desktop environment — the one piece meant to be swappable), `git.nix`,
  `dev.nix`.
- `modules/hosts/<name>/` — `configuration.nix` produces
  `nixosConfigurations.<name>`, `home.nix` produces a standalone
  `homeConfigurations."ben@<name>"` and the homeModule reused inside the
  NixOS config. Each host just lists which features it wants.

## Current status

**laptop** is fully wired up: niri, git, dev tooling. **desktop** and
**server** are deliberately minimal stubs — common system settings only, no
desktop environment, no extras — ready to extend by copying laptop's pattern
once you can actually test on those machines. Look for `TODO` comments.

## Trying it out, step by step

**1. Validate without touching anything.** From any machine with Nix
installed — including WSL on this same Windows laptop, no need to boot
anything yet — clone the repo and run:

```
nix flake check
nix build .#nixosConfigurations.laptop.config.system.build.toplevel
```

This catches typos and bad options by actually building the full system
closure, with zero risk to your current install. You can also sanity-check
just the home-manager side, which works on non-NixOS systems too:

```
nix run home-manager/master -- switch --flake .#ben@laptop
```

(niri itself won't run inside WSL, but this confirms git/direnv/packages
activate cleanly.)

**2. Get the real hardware config, still without installing.** Boot a NixOS
installer USB on the laptop — this doesn't touch Windows at all. From the
live session:

```
nixos-generate-config --show-hardware-config
```

Copy that output into `modules/hosts/laptop/hardware-configuration.nix`,
replacing the placeholder. Re-run step 1 to confirm it still builds with
real hardware data.

**3. Fill in the `CHANGEME`s.** At minimum, your git name and email in
`modules/features/git.nix`.

**4. When you're ready — and once your NAS backup is actually done — do the
real install.** From the live USB: partition and mount your target disks,
then from inside the repo:

```
sudo nixos-install --flake .#laptop
```

Reboot, and you should land on greetd, ready to log into niri.

## niri-flake and Noctalia

`niri.nix` goes through `sodiboo/niri-flake` instead of plain nixpkgs:
your config is build-time-validated Nix (`programs.niri.settings`) instead
of a hand-written KDL string, niri gets its own binary cache automatically,
and its version is pinned independently of the rest of nixpkgs. The shell
on top — bar, launcher, notifications, theming, wallpaper — is Noctalia,
in its own `noctalia.nix` file rather than bundled into `niri.nix`,
specifically so swapping the shell later never touches the compositor
file. `noctalia.nix` registers its own startup with niri by reaching into
`programs.niri.settings.spawn-at-startup` from its own file — `niri.nix`
stays unaware of whatever shell, if any, is layered on top of it.

Niri's own home-manager module for this doesn't exist upstream in
nix-community/home-manager yet (there's an open PR) — niri-flake is doing
that job in the meantime. Whenever it lands, the swap stays contained to
`niri.nix`.
