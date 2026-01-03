{
  flake.modules.homeManager.neovim =
    { config, pkgs, ... }:
    let
      configRepo = "${config.home.homeDirectory}/dtfls";
    in
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withPython3 = true;
        extraPackages = with pkgs; [
          go
          python3
          luarocks
          tree-sitter
          imagemagick
          tectonic
          ghostscript
          mermaid-cli
          statix
          cargo
          unzip
          gcc
        ];
      };

      # use the "raw" nvim config from this repo
      xdg.configFile = {
        nvim = {
          source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/nvim";
          recursive = true;
        };
      };
    };
}
