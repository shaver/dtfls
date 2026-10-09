{
  # the agent itself is started by programs.ssh.startAgent in shaver-base on
  # nixos; macOS runs its own
  flake.modules.hjem.ssh = {
    files.".ssh/config".text = ''
      Host github.com
        IdentityFile ~/.ssh/id_github

      Host *
        IgnoreUnknown UseKeychain
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
        UseKeychain yes
    '';
  };
}
