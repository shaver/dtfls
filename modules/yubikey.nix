{
  flake.modules.nixos.yubikey =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yubikey-manager
        yubikey-personalization
        yubico-piv-tool
      ];

      services.udev.packages = [ pkgs.yubikey-personalization ];
    };
}
