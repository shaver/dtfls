{
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;
      casks = [
        "alacritty"
        "discord"
        "iterm2"
        "kitty"
      ];
    };
  };
}
