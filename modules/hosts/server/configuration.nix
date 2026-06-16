# Minimal on purpose — no desktop environment here at all, headless by
# design. Add services.openssh + your public key once this host is ready.
{ self, inputs, ... }: {
  flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.serverModule
      self.nixosModules.myHomeManager
    ];
  };

  flake.nixosModules.serverModule = { ... }: {
    imports = [
      ./hardware-configuration.nix
      self.nixosModules.common
    ];

    networking.hostName = "server";
    nixpkgs.hostPlatform = "x86_64-linux";

    home-manager.users.ben = self.homeModules.benServer;
  };
}
