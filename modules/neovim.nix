{ inputs, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    let
      # Build plugins not available in nixpkgs from flake inputs
      jjsigns-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "jjsigns-nvim";
        src = inputs.jjsigns-nvim;
      };

      jiaoshijie-undotree = pkgs.vimUtils.buildVimPlugin {
        name = "undotree";
        src = inputs.jiaoshijie-undotree;
      };

      tmux-status-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "tmux-status-nvim";
        src = inputs.tmux-status-nvim;
      };
    in
    {
      packages = {
        neovim = (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            ../config/nvf.nix
            {
              # Inject the non-nixpkgs plugin packages into the module
              vim.extraPlugins = {
                jjsigns-nvim.package = jjsigns-nvim;
                jiaoshijie-undotree.package = jiaoshijie-undotree;
                tmux-status-nvim.package = tmux-status-nvim;
              };
            }
          ];
        }).neovim;

        default = config.packages.neovim;
      };

      # Also expose as an app so `nix run` works
      apps.default = {
        type = "app";
        program = "${config.packages.neovim}/bin/nvim";
      };
    };
}
