# A Godot reusable Dev Shell
I'm developing games using godot and in the nixos-unstable branch there's only the latest stable version of Godot, but I want to be able to use different versions, not only the stable one, so I created this devshell to use it in multiple projects without copy/pasting the same flake.
### Usage:
```nix
# flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.godot-shell.url = "github:bkerz/godot-devshell";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    godot-shell,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      version = "4.3-rc2";
      hash = "sha256-rBVP1QFy7f7GHJFf/EsWh9M0uLbHwZXfyclGjjl8fls=";
      shell = godot-shell.lib.devShell {
        inherit pkgs;
        version = version;
        hash = hash;
      };
    in {
      devShell = shell;
    });
}

# terminal
nix develop
```

Note: I wasn't able to make the `runScript` work and this devshell will only work for non stable builds for now, but I'll work on support stable builds and make the `runScript` work.
