{
  description = "Statusline in the best language ever";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
  in {
    packages.x86_64-linux.default = pkgs.callPackage ./default.nix {};
    devShells.x86_64-linux.default = import ./shell.nix { inherit pkgs; };
  };
}
