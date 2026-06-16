# Shared system-level config, used by every host regardless of desktop
# environment. Touch this once, every host gets the change.
{ ... }: {
  flake.nixosModules.common = { pkgs, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    networking.networkmanager.enable = true;
    time.timeZone = "Europe/Stockholm"; # CHANGEME if this isn't right
    i18n.defaultLocale = "en_US.UTF-8";

    # Assumes a UEFI machine, which covers most modern hardware.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    programs.zsh.enable = true;
    users.users.ben = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "input" ];
      shell = pkgs.zsh;
    };

    # Set once at first install, then left alone — don't bump this later.
    system.stateVersion = "25.11";
  };
}
