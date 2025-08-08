{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = inputs: let
    inherit (inputs) self nixpkgs;
    forEachSystem = let
      inherit (nixpkgs.lib) genAttrs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-linux"
      ];
    in
      f: genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    packages =
      forEachSystem
      (pkgs: {
        flake-update-tags = pkgs.callPackage ./package.nix {inherit self;};
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.flake-update-tags;
      });
  };
}
