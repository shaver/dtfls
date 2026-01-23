{ inputs, ... }: {
  flake.modules.nixos.shaver-personal-desktop = {
    home-manager.users.shaver = {
      imports = with inputs.self.modules.homeManager; [
        shaver-3d-printing
        shaver-personal-nixos-desktop
        gaming # probably want to be able to mix this into per-host config...
      ];
    };
  };

  flake.modules.nixos.shaver-personal = {
    imports = [ inputs.self.modules.nixos.shaver-base ];
    home-manager.users.shaver = {
      imports = with inputs.self.modules.homeManager; [ shaver-personal-nixos ];
    };

    users.users.shaver.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
    ];
  };

  flake.modules.homeManager.shaver-personal-darwin = {
    imports = with inputs.self.modules.homeManager; [ shaver-personal ];
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

  flake.modules.homeManager.shaver-personal-nixos = {
    imports = with inputs.self.modules.homeManager; [ shaver-personal ];
  };

  flake.modules.homeManager.shaver-personal = {
    imports = with inputs.self.modules.homeManager;
      [ shaver-base shaver-secrets ]
      ++ (with inputs.self.modules.homeManager; [ irssi ]);
  };

  flake.modules.darwin.shaver-personal = {
    imports = with inputs.self.modules.darwin; [
      shaver-base
      aerospace
      homebrew
    ];

    home-manager.users.shaver = {
      imports = with inputs.self.modules.homeManager;
        [ shaver-personal-darwin ];
    };

    users.users.shaver.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
    ];

  };
}
