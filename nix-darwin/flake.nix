{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [
            pkgs.git
            pkgs.wget
            pkgs.glow
            pkgs.nixfmt-rfc-style
            pkgs.direnv
            pkgs.devenv
            pkgs.neovim
            pkgs.kubectl
            pkgs.kustomize
            pkgs.fzf
            pkgs.ripgrep
            pkgs.atuin
            pkgs.starship
            pkgs.btop
            pkgs.tmux
            pkgs.devbox
            pkgs.lua5_4_compat
            pkgs.awscli2
            pkgs.aws-sso-cli
            pkgs.aws-vault
            pkgs.amazon-ssm-agent
            pkgs.terraform
            pkgs.k9s
            pkgs.lazygit
            pkgs.docker-client
            pkgs.colima
            pkgs.podman
            pkgs.docker-compose
            pkgs.docker-compose
            pkgs.docker-buildx
            pkgs.docker-credential-helpers
            pkgs.pyenv
            pkgs.nixpkgs-fmt
            pkgs.yazi
            pkgs.dive
            pkgs.cue
            pkgs.google-java-format
            pkgs.yamlfmt
            pkgs.graphviz
            pkgs.gh
            pkgs.jira-cli-go
          ];

          system.primaryUser = "john.girvan";
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          programs.zsh = {
            enable = true;
          };
          environment.etc = {
            "zshenv" = {
              text = ''
                export ZDOTDIR="$HOME/.config/zsh"
              '';
            };
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          security.pam.services.sudo_local.touchIdAuth = true;

          system.defaults = {
            dock.autohide = true;
            dock.mru-spaces = false;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            screencapture.location = "~/Pictures/screenshots";
          };

          # Homebrew needs to be installed on its own!
          homebrew.enable = true;
          homebrew.taps = [
            "FelixKratz/formulae"
            "omnisharp/omnisharp-roslyn"
            "deviceinsight/packages"
          ];
          homebrew.casks = [
            "nikitabobko/tap/aerospace"
            "obsidian"
            "vmware-fusion"
            "visual-studio-code"
            "dbeaver-community"
          ];
          homebrew.brews = [
            "sketchybar"
            "borders"
            "ical-buddy"
            "watch"
            "kafka"
            "omnisharp-mono"
            "deviceinsight/packages/kafkactl"
            "deviceinsight/packages/kafkactl-aws-plugin"
            "jj"
            "lazyjj"
            "helm"
            "nerdctl"
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#LM-CLJ9Y5YGN4
      darwinConfigurations."LM-CLJ9Y5YGN4" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
