{ self, inputs, ... }: {
  # Standalone — lets you test the home-manager side on its own with
  # `home-manager switch --flake .#ben@laptop`, even from a non-NixOS
  # machine (niri itself just won't run there).
  flake.homeConfigurations."ben@laptop" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      inputs.niri.homeModules.config
      self.homeModules.benLaptop
      {
        home.username = "ben";
        home.homeDirectory = "/home/ben";
      }
    ];
  };

  # Reused above and inside laptop's NixOS configuration.
  flake.homeModules.benLaptop = { ... }: {
    imports = [
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.git
      self.homeModules.dev
      self.homeModules.entertainment
    ];

    home.stateVersion = "25.11";
  };
}
