{ self, inputs, ... }: {
  flake.homeConfigurations."ben@server" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.benServer
      {
        home.username = "ben";
        home.homeDirectory = "/home/ben";
      }
    ];
  };

  flake.homeModules.benServer = { ... }: {
    imports = [
      self.homeModules.git
      self.homeModules.dev
    ];

    home.stateVersion = "25.11";
  };
}
