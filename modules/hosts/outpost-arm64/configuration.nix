{ inputs, ... }: {
  flake.modules.nixos.outpost-arm64 = { pkgs, ... }: {
    imports = [
      inputs.determinate.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ] ++ (with inputs.self.modules.nixos; [
      base-system
      base-networking
      shaver-personal
    ]) ++ (with inputs.self.commonModules; [ sudo nix ]);

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGzbYo5LNxt7y+hba7OqKoBM38sIrJUPY40n5susOadd"
    ];
  };
}
