{ inputs, ... }:
{
  flake.modules.darwin.shaver-work = {
    imports = with inputs.self.modules.darwin; [
      shaver-base
      aerospace
      homebrew
      mac-app-store
    ];

    hjem.users.shaver = {
      imports = with inputs.self.modules.hjem; [ shaver-work ];
    };
  };

  flake.modules.hjem.shaver-work =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        shaver-base
        obsidian
      ];
      packages = with pkgs; [
        go-junit-report
        golangci-lint
      ];
    };
}
