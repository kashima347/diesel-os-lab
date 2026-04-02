{
  description = "Diesel OS Lab ISO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/1073dad219cb244572b74da2b20c7fe39cb3fa9e";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./iso/default.nix
        ];
      };

      nixosConfigurations.lab = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos-machines/hal/configuration.nix
        ];
      };
    };
}
