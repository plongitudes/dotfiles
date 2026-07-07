{
  description = "Nix home-manager configurations (Darwin + Linux profiles)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      darwinSystem = "aarch64-darwin";
      # linuxSystem = "x86_64-linux";  # reserved for the linux-* profile at M6+

      # Build a standalone home-manager config from the shared module plus any
      # profile-specific modules. Username/home-dir are derived from $USER at build
      # time (see home/common/default.nix), so nothing here identifies a machine —
      # which is also why every build needs `--impure` (getEnv is impure).
      mkHome = { system ? darwinSystem, modules ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home/common/default.nix ] ++ modules;
        };
    in {
      # Generic, non-machine-identifying profiles (OS + role). Which one a machine
      # builds is chosen at runtime via ~/.config/dotfiles/profile — see switch()
      # in aliases.zsh. darwin-personal/darwin-work are identical today; add
      # `modules = [ ./home/common/work.nix ]` to darwin-work when it diverges.
      homeConfigurations = {
        darwin-personal = mkHome { };
        darwin-work = mkHome { };
      };

      # Reserved for M6+ — full NixOS host config for the homelab VM:
      #
      # nixosConfigurations.linux-homelab = nixpkgs.lib.nixosSystem {
      #   system = linuxSystem;
      #   modules = [
      #     ./hosts/linux-homelab
      #     home-manager.nixosModules.home-manager
      #     { home-manager.users.<user> = import ./home/common/default.nix; }
      #   ];
      # };
    };
}
