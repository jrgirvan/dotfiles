{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages =
        [
pkgs.git
pkgs.glow
pkgs.direnv
pkgs.devenv
pkgs.neovim
pkgs.kubectl
pkgs.fzf
pkgs.ripgrep
pkgs.atuin
pkgs.starship
pkgs.btop
pkgs.tmux
pkgs.go
pkgs.devbox
pkgs.lua5_4_compat
pkgs.awscli2
pkgs.aws-sso-cli
pkgs.aws-vault
pkgs.terraform
pkgs.kind
                        pkgs.docker-client
                        pkgs.colima
                        pkgs.docker-compose
                        pkgs.docker-buildx
                        pkgs.docker-credential-helpers
                        pkgs.pyenv
           pkgs.nixpkgs-fmt
                        pkgs.yazi
        ];
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
                ];
      homebrew.casks = [
                    "nikitabobko/tap/aerospace"
                    "obsidian"
                    "vmware-fusion"
      ];
      homebrew.brews = [
                    "sketchybar"
                    "borders"
                    "ical-buddy"
                    "watch"
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
