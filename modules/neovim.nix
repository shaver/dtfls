{
  flake.modules.hjem.neovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      configRepo = "${config.directory}/dtfls";
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
        ghc
        hlint # haskell
      ];
    in
    {
      packages = [
        (pkgs.neovim.override {
          viAlias = true;
          vimAlias = true;
          withNodeJs = true;
          withPython3 = true;
          extraMakeWrapperArgs = "--suffix PATH : ${lib.makeBinPath extraPackages}";
        })
        (pkgs.writeShellScriptBin "vimdiff" ''exec nvim -d "$@"'')
      ];
      environment.sessionVariables.EDITOR = "nvim";

      # use the "raw" nvim config from this repo
      xdg.config.files.nvim.source = "${configRepo}/config/nvim";
    };
}
