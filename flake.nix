{
	description = "A reusable Dev Shell for using Godot from its release repositories";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # outputs = {
  #   self,
  #   nixpkgs,
  #   flake-utils,
  # }:
  #   flake-utils.lib.eachDefaultSystem (system: let
  #     pkgs = nixpkgs.legacyPackages.${system};
  #     version = "4.3-rc1";
  # 	godot-shell = import ./godot-shell.nix {inherit pkgs version;};
  #   in {
  #     devShell = godot-shell;
  #   });

	  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    in
    {
      lib = {
        devShell = { pkgs, version, ... }: 
          import ./shell.nix { inherit pkgs version; };
      };
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
	  version = "4.3-rc1";
        in
        {
          default = import ./shell.nix { inherit pkgs version;};
        }
      );
    };
}
