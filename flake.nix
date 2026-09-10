{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://projects.cache.profidev.io"
      "http://192.168.178.22:80"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
    ];
    connect-timeout = 5;
    fallback = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    custom-nixpkgs.url = "github:ProfiiDev/custom-nixpkgs";

    proton.url = "github:profiidev/proton/latest";
    positron.url = "github:profiidev/positron/latest";
    hibernation.url = "github:profiidev/hibernation/latest";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-secrets.url = "git+ssh://git@github.com/ProfiiDev/nix-secrets.git?ref=main&shallow=1";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-citizen = {
      url = "github:LovingMelody/nix-citizen?rev=cb5c54868dfca5377f0fea5c983aef833acdd4b5";
      inputs = {
        nix-gaming.follows = "nix-gaming";
      };
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      ...
    }:
    let
      specialArgs = pkgs: {
        inherit inputs self;
        lib = pkgs.lib.extend (
          self: super: {
            custom = import ./lib { inherit (pkgs) lib; };
          }
        );
      };
    in
    {
      modules = import ./modules { lib = nixpkgs-unstable.lib; };

      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs-unstable.lib.nixosSystem {
            specialArgs = specialArgs nixpkgs-unstable // {
              inherit host;
              isLinux = true;
            };
            modules = [ ./hosts/linux/${host} ];
          };
        }) (nixpkgs-unstable.lib.attrNames (builtins.readDir ./hosts/linux))
      );

      # https://nix-darwin.github.io/nix-darwin/manual/index.html
      darwinConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nix-darwin.lib.darwinSystem {
            specialArgs = specialArgs nixpkgs-unstable // {
              inherit host;
              isLinux = false;
            };
            modules = [ ./hosts/mac/${host} ];
          };
        }) (nixpkgs.lib.attrNames (builtins.readDir ./hosts/mac))
      );
    };
}
