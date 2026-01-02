{ inputs, ... }:
{
  flake.modules.nixos.shaver =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      # wire up basic user configuration
      users.users.shaver = {
        isNormalUser = true;
        description = "Mike Shaver";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
      };

      programs.zsh.enable = true;
      programs.firefox.enable = true;

      # bring in Home Manager
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager.users.shaver = {
        imports = [
          inputs.self.modules.homeManager.shaver
        ];
      };
    };
}
