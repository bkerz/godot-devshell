{
	description = "A reusable Dev Shell for using Godot from its release repositories";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    in
    {
      lib = {
        devShell = { pkgs, version, hash... }: 
          import ./shell.nix { inherit pkgs version hash; };
      };
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
	  version = "4.3-rc1";
	  hash = "sha256-gZjHvouEBUkaGLEFNyIhin9AA2UCaBWULiKgoTxarCY=";
        in
        {
          default = import ./shell.nix { inherit pkgs version hash;};
        }
      );
    };
}
