{ inputs, ... }:
{
  flake.modules.hjem.pi-coding-agent =
    { config, osConfig, ... }:
    let
      cfg = config.programs.pi.coding-agent;
    in
    {
      # binary cache
      nix.settings = {
        extra-substituters = [
          "https://pi.cachix.org"
        ];
        extra-trusted-public-keys = [
          "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
        ];
      };

      # pi only ships nixos and home-manager modules, but both are thin
      # wrappers around this shared options module
      imports = [
        (import "${inputs.pi}/coding-agent/options.nix" {
          self = inputs.pi;
          inherit (inputs.pi.inputs) jail-nix;
          optionPath = [
            "programs"
            "pi"
            "coding-agent"
          ];
        })
      ];

      programs.pi.coding-agent.wsl = osConfig.wsl.enable or false;
      packages = [ cfg.finalPackage ];
    };
}
