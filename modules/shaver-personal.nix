{ inputs, ... }:
{
  flake.modules.nixos.shaver-personal-desktop = {
    hjem.users.shaver = {
      imports = with inputs.self.modules.hjem; [
        shaver-personal-nixos-desktop
      ];
    };
  };

  flake.modules.nixos.shaver-personal = {
    imports = with inputs.self.modules; [
      nixos.shaver-base
      generic.shaver-secrets
    ];
    hjem.users.shaver = {
      imports = with inputs.self.modules.hjem; [
        shaver-personal-nixos
      ];
    };

    users.users.shaver.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
    ];
  };

  flake.modules.hjem.shaver-personal-darwin = {
    imports = with inputs.self.modules.hjem; [ shaver-personal ];
  };

  flake.modules.hjem.shaver-personal-nixos-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        niri
        noctalia
        desktop
      ];
      packages = with pkgs; [
        signal-desktop
        discord
        vesktop
      ];
    };

  flake.modules.hjem.shaver-personal-nixos = { pkgs, ... }: {
    imports = with inputs.self.modules.hjem; [
      shaver-personal
      music
    ];
    packages = [ pkgs.hcloud ];
  };

  # secrets are decrypted at the system level, see generic.shaver-secrets
  flake.modules.hjem.shaver-personal = {
    imports = with inputs.self.modules.hjem; [
      shaver-base
      irssi
    ];
  };

  flake.modules.darwin.shaver-personal = {
    imports =
      (with inputs.self.modules.darwin; [
        shaver-base
        aerospace
        homebrew
      ])
      ++ [ inputs.self.modules.generic.shaver-secrets ];

    hjem.users.shaver = {
      imports = with inputs.self.modules.hjem; [
        shaver-personal-darwin
        alacritty
      ];
    };

    users.users.shaver.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
    ];

  };
}
