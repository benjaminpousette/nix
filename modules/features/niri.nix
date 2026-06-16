# The compositor aspect — the one piece meant to be swappable. niri now
# goes through niri-flake instead of plain nixpkgs: same
# programs.niri.enable option you had before, but config is now
# build-time-validated Nix instead of hand-written KDL, with its own
# binary cache (enabled automatically by niri-flake's module) and
# independent version pinning from the rest of nixpkgs.
{ inputs, ... }: {
  flake.nixosModules.niri = { pkgs, config, ... }: {
    imports = [ inputs.niri.nixosModules.niri ];
    programs.niri.enable = true;
    xdg.portal.enable = true;

    services.greetd = {
      enable = true;
      settings.default_session.command = "${config.programs.niri.package}/bin/niri-session";
    };
  };

  # Imports niri.homeModules.config explicitly so this also works through
  # the standalone homeConfigurations path, not just the integrated one
  # (where niri-flake would auto-import it for you).
  flake.homeModules.niri = { ... }: {
    imports = [ inputs.niri.homeModules.config ];

    programs.kitty.enable = true;

    programs.niri.settings = {
      input.keyboard.xkb = { };
      input.touchpad.tap = true;
      layout.gaps = 16;

      binds = {
        "Mod+Return".action.spawn = [ "kitty" ];
        "Mod+Q".action = "close-window";
        "Mod+Shift+E".action = "quit";
        # TODO: add a bind to toggle Noctalia's launcher once you've
        # checked the exact IPC invocation in Noctalia's current docs.
      };
      # Note: spawn-at-startup for this session isn't set here — Noctalia
      # (or whatever shell is active) registers its own startup line from
      # its own feature file. Check noctalia.nix if you're looking for it.
    };
  };
}
