{ inputs, ... }: {
  flake.modules.homeManager.shaver-personal-darwin = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [ shaver-personal ];
    home.packages = with pkgs; [ less coreutils ];
  };
  flake.modules.homeManager.shaver-personal-nixos-desktop = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [
      shaver-personal-nixos
      niri
      noctalia
      desktop
    ];
    home.packages = with pkgs; [ signal-desktop ];
  };
  flake.modules.homeManager.shaver-personal-nixos = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [ shaver-personal ];
  };
  flake.modules.homeManager.shaver-personal = { flake, pkgs, config, ... }: {
    imports = with inputs.self.modules.homeManager;
      [ shaver-base shaver-secrets ]
      ++ (with inputs.self.modules.homeManager; [ irssi ]);
  };
}
