{ ... }: {
  flake.homeModules.git = { ... }: {
    programs.git.enable = true;
    programs.git.userName = "Benjamin Pousette";
    programs.git.userEmail = "benjamin.pousette1999@gmail.com";
  };
}
