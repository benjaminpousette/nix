# Wires home-manager in as a NixOS module so a single `nixos-rebuild
# switch` updates system and user config together. Shared by every host.
{ inputs, ... }: {
  flake.nixosModules.myHomeManager = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.default ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
