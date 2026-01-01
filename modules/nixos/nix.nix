{
  flake.modules.nixos.nix = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
