# dtfls

an attempt at
[dendritic](https://github.com/Doc-Steve/dendritic-design-with-flake-parts/tree/main)
configuration of nixos and nix-darwin and home-manager

largely built atop the endless patience of
[@Michael-C-Buckley](https://github.com/Michael-C-Buckley) and the other
denizens of the [vimjoyer discord](https://discord.gg/4PRCEduR)

I sometimes force-push so track at your peril

## todo

- set up the nix-darwin stuff
  - [x] daltron
    - [ ] [paneru](https://github.com/karinushka/paneru)?
  - [ ] work laptop with gibberish name
    - [ ] switch to alacritty
- splashdown:
  - [x] some sort of desktop setup
    - [x] try noctalia
  - [x] [xlm](https://github.com/Blooym/xlm/issues/27#issuecomment-2925634085)
  - [ ] patched kernel ([patch][rtl-patch]; [process][nixos-kernel-hacking])
  - fix sleep?
- [x] sops for private keys!
  - [x] shaver: ffxiv
  - [ ] shaver: github ssh
  - [ ] shaver: gh token
  - [ ] shaver: HA token
  - [ ] system: tailscale key
  - yubikey to unlock?
  - work secrets?
- nvim
  - [ ] mason garbage
  - [ ] marksman linking issue
  - [ ] look at <https://github.com/pfassina/lazyvim-nix> and <https://github.com/b-src/lazy-nix-helper.nvim>
- program configurations
  - [x] tmux
  - [x] alacritty
- incus for containers and VMs

[rtl-patch]: https://www.spinics.net/lists/netdev/msg1147783.html
[nixos-kernel-hacking]: https://uninsane.org/blog/nixos-kernel-hacking/
