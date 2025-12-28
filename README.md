Desiderata for flake:
- nixos common: directory of modules
- darwin common: directory of modules (can this share with nixos)
- per-host: directory, includes hardware-configuration.nix
- home common: directory of modules
- home per host (like the Fastly stuff for work): subdir of home per-host if exists

Structure:

phoe-nix/
├── flake.lock
├── flake.nix
├── home
│   ├── darwin
│   ├── default.nix
│   ├── git.nix
│   ├── hosts
│   │   ├── splashdown
│   │   │   ├── default.nix
│   │   │   └── signal.nix
│   │   └── work-laptop
│   │       ├── default.nix
│   │       └── fastly.nix
│   ├── jj.nix
│   ├── neovim.nix
│   ├── nixos
│   ├── wsl
│   └── zsh.nix
├── hosts
│   ├── daltron
│   │   ├── default.nix
│   │   └── home-assistant.nix
│   ├── some-wsl
│   ├── splashdown
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── work-laptop
│       ├── default.nix
│       └── macos-config.nix
├── platform
│   ├── darwin
│   │   ├── aerospace.nix
│   │   └── default.nix
│   ├── nixos
│   │   ├── default.nix
│   │   └── desktop.nix
│   └── wsl
│       ├── default.nix
│       └── some-wsl-thing.nix
└── README.md
