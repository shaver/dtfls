{ inputs, ... }:
{
  flake.modules.darwin.shaver-work = {
    imports = with inputs.self.modules.darwin; [
      shaver-base
      aerospace
      homebrew
      mac-app-store
    ];

    home-manager.users.shaver = {
      imports = with inputs.self.modules.homeManager; [ shaver-work ];
    };
  };

  flake.modules.homeManager.shaver-work =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        shaver-base
        obsidian
      ];
      home.packages = with pkgs; [
        go-junit-report
        golangci-lint
      ];
    };
}
