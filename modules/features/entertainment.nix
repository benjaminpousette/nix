{ ... }: {
    flake.homeModules.entertainment = { pkgs, ... }: {
        programs.equibop.enable = true;
        
	home.packages = with pkgs; [
		steam
		cowsay
	];
      
  };
}
