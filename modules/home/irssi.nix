{
  flake.modules.homeManager.irssi = {
    programs.irssi = {
      enable = true;
      networks.sizone = {
        # just for old time's sake
        server = {
          address = "irc.sizone.org";
          autoConnect = true;
        };
        nick = "shaver";
        channels."#tek".autoJoin = true;
      };
    };
  };
}
