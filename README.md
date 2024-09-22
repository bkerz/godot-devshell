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
      version = "stable"; # "stable" or any other verion (e.g 4.4-dev2)
      hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; # replace this hash with the one `nix develop` gives after failing
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

godot -e path/to/your/project.godot
```

Note: I wasn't able to make the `runScript` work. I still don't know why it doesn't work I'll try to find a solution for that later.
