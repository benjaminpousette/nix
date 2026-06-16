# Phase-4 dev tooling: direnv + nix-direnv for per-project shells.
{ ... }: {
  flake.homeModules.dev = { pkgs, ... }: {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    home.packages = with pkgs; [ ripgrep fd htop ];
  };
}
