{ inputs, ... }:
{
  flake.modules.darwin.shaver-work = {
    imports = with inputs.self.modules.darwin; [
      shaver-base
      aerospace
      homebrew
    ];

    home-manager.users.shaver = {
      imports = with inputs.self.modules.homeManager; [ shaver-work ];
    };
  };

  flake.modules.homeManager.shaver-work =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [ shaver-base ];
      home.packages = with pkgs; [
        go-junit-report
        golangci-lint

        claude-code
      ];
    };
}
