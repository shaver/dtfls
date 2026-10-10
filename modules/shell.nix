{
  flake.modules.hjem.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
      # https://github.com/NixOS/nixpkgs/issues/513019 -- direnv/zsh badness
      direnv = pkgs.direnv.overrideAttrs { doCheck = false; };
    in
    {
      packages = with pkgs; [
        jj-starship
        zsh
        direnv
        fzf
        zoxide
        starship
      ];

      files.".zshenv".source = config.environment.loadEnv;

      # compinit and NIX_PROFILES fpath handling come from the system zshrc
      files.".zshrc".text = lib.mkMerge [
        (lib.mkBefore ''
          # Use emacs keymap as the default.
          bindkey -e

          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          ZSH_AUTOSUGGEST_STRATEGY=(history)

          HISTSIZE="10000"
          SAVEHIST="10000"
          HISTFILE="$HOME/.zsh_history"
          setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
          setopt NO_APPEND_HISTORY NO_EXTENDED_HISTORY NO_HIST_EXPIRE_DUPS_FIRST
          setopt NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS
        '')
        (lib.mkAfter ''
          eval "$(${lib.getExe direnv} hook zsh)"
          source <(${lib.getExe pkgs.fzf} --zsh)
          # Type `z <pat>` to cd to some directory
          eval "$(${lib.getExe pkgs.zoxide} init zsh)"
          eval "$(${lib.getExe pkgs.starship} init zsh)"
        '')
        # must come after everything else that touches zle, including the
        # integrations above, which are mkAfter
        (lib.mkOrder 2000 ''
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
        '')
      ];

      xdg.config.files = {
        # silent
        "direnv/direnv.toml".source = toml.generate "direnv-config.toml" {
          global = {
            log_format = "-";
            log_filter = "^$";
          };
        };
        "direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";

        # Better shell prompt!
        "starship.toml".source = toml.generate "starship.toml" {
          custom.jj = {
            when = "jj-starship detect";
            shell = [ "jj-starship" ];
            format = "$output ";
          };
          format = "$all$jj$line_break$shell$character";
          right_format = "$time$nix_shell";
          username = {
            style_user = "blue bold";
            style_root = "red bold";
            format = "[$user]($style) ";
            disabled = false;
            show_always = false;
          };
          hostname = {
            ssh_only = true;
            ssh_symbol = "🌐 ";
            format = "on [$hostname](bold red) ";
            trim_at = ".local";
            disabled = false;
          };
          git_branch.disabled = true;
          git_commit.disabled = true;
          git_status.disabled = true;
          nix_shell = {
            symbol = "❄️";
            format = "[\\($symbol$name\\)]($style) ";
          };
        };
      };
    };
}
