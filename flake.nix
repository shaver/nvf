{
  description = "Neovim configuration via nvf (converted from LazyVim)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins not available in nixpkgs
    jjsigns-nvim = {
      url = "github:shaver/jjsigns.nvim";
      flake = false;
    };
    jiaoshijie-undotree = {
      url = "github:jiaoshijie/undotree";
      flake = false;
    };
    tmux-status-nvim = {
      url = "github:christopher-francisco/tmux-status.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ ./modules/neovim.nix ];
    };
}
