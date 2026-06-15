{
  description = "tonye's Nix configurations: Mac (laptop-dev-portmantopia) + Unraid VM (server-homelab-inverness)";

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
      # linuxSystem = "x86_64-linux";  # will be used for server-homelab-inverness in M7
    in {
      homeConfigurations.laptop-dev-portmantopia = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${darwinSystem};
        modules = [ ./home/tonye/default.nix ];
      };

      # Reserved for M7 — full NixOS host config for the Unraid VM:
      #
      # nixosConfigurations.server-homelab-inverness = nixpkgs.lib.nixosSystem {
      #   system = linuxSystem;
      #   modules = [
      #     ./hosts/server-homelab-inverness
      #     home-manager.nixosModules.home-manager
      #     { home-manager.users.tonye = import ./home/tonye/default.nix; }
      #   ];
      # };
    };
}
