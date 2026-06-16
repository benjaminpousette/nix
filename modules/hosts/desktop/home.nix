{ self, inputs, ... }: {
  flake.homeConfigurations."ben@desktop" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.benDesktop
      {
        home.username = "ben";
        home.homeDirectory = "/home/ben";
      }
    ];
  };

  # TODO: imports = [ self.homeModules.niri self.homeModules.git
  # self.homeModules.dev ] once this host is ready, same as laptop.
  flake.homeModules.benDesktop = { ... }: {
    imports = [
      self.homeModules.git
      self.homeModules.dev
    ];

    home.stateVersion = "25.11";
  };
}
