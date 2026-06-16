# Minimal on purpose — fill in once you can actually test on this machine.
# Copy laptop's pattern: add self.nixosModules.niri (or whichever DE you
# land on) plus a gaming feature module to the modules list below.
{ self, inputs, ... }: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopModule
      self.nixosModules.myHomeManager
    ];
  };

  flake.nixosModules.desktopModule = { ... }: {
    imports = [
      ./hardware-configuration.nix
      self.nixosModules.common
    ];

    networking.hostName = "desktop";
    nixpkgs.hostPlatform = "x86_64-linux";

    home-manager.users.ben = self.homeModules.benDesktop;
  };
}
