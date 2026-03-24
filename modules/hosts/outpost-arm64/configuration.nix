{ inputs, ... }:
{
  flake.modules.nixos.outpost-arm64 =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        base-networking
        shaver-personal
      ];

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGzbYo5LNxt7y+hba7OqKoBM38sIrJUPY40n5susOadd"
      ];
    };
}
