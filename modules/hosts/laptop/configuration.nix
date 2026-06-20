{ self, inputs, ... }: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopModule
      self.nixosModules.myHomeManager
      self.nixosModules.niri
      self.nixosModules.noctalia
    ];
  };

  flake.nixosModules.laptopModule = { ... }: {
    imports = [
      ./_hardware-configuration.nix
      self.nixosModules.common
    ];

    networking.hostName = "laptop";
    nixpkgs.hostPlatform = "x86_64-linux";

    home-manager.users.ben = self.homeModules.benLaptop;
  };
}
