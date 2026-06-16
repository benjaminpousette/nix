# The shell aspect — bar, launcher, notifications, lock screen, wallpaper.
# Split from niri.nix on purpose: this is what sits on top of the
# compositor, not the compositor itself. Swapping shells later (back to
# waybar+fuzzel+mako, or to something else) means editing this file only —
# niri.nix never needs to know what's layered on top of it.
{ inputs, ... }: {
  flake.nixosModules.noctalia = { ... }: {
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    # Noctalia's own requirements for its wifi/bluetooth/power/battery
    # widgets, straight from their quickstart. networking.networkmanager
    # is already on in common.nix — repeated here too so this file states
    # everything it needs on its own, regardless of what else is enabled
    # elsewhere.
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };

  flake.homeModules.noctalia = { ... }: {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.noctalia = {
      enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = false;
          default.path = "/path/to/wallpapers/wallpaper.png"; # CHANGEME if you turn this on
        };
      };
    };

    # The actual invocation, straight from Noctalia's quickstart for niri —
    # much simpler than the qs -c noctalia-shell form guessed at earlier.
    programs.niri.settings.spawn-at-startup = [
      { command = [ "noctalia" ]; }
    ];
  };
}
