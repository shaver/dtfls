{
  flake.modules.nixos.desktop = {
    # Enable the KDE Plasma Desktop Environment.
    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
    programs.niri.enable = true;
  };
}
