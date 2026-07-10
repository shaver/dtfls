{ inputs, ... }:
{
  flake.modules.homeManager.pi-coding-agent = {
    # binary cache
    nix.settings = {
      extra-substituters = [
        "https://pi.cachix.org"
      ];
      extra-trusted-public-keys = [
        "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      ];
    };

    imports = [ inputs.pi.homeModules.default ];

    programs.pi.coding-agent = {
      enable = true;
    };
  };
}
