{
	pkgs,
	version ? "stable",
	hash ? "",
}: let
			name = "godot";
			stableVersion = "4.3-stable";
			stableUrl = "https://github.com/godotengine/godot/releases/download/${stableVersion}/Godot_v${stableVersion}_linux.x86_64.zip";
			unstableUrl = "https://github.com/godotengine/godot-builds/releases/download/${version}/Godot_v${version}_linux.x86_64.zip";
			isStable = version == "stable";
      godot-stable = pkgs.fetchurl {
        url = if isStable then stableUrl else unstableUrl;
        hash = if builtins.isString hash && hash != "" then hash else "sha256-gZjHvouEBUkaGLEFNyIhin9AA2UCaBWULiKgoTxarCY=";
      };

      buildInputs = with pkgs; [
        alsa-lib
        dbus
        fontconfig
        libGL
        libpulseaudio
        libxkbcommon
        makeWrapper
        mesa
        patchelf
        speechd
        udev
        vulkan-loader
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXinerama
        xorg.libXrandr
        xorg.libXrender
      ];

		 godot-unwrapped = pkgs.stdenv.mkDerivation {
				name = name;
				pname = name;

				src = godot-stable;
				nativeBuildInputs = with pkgs; [unzip autoPatchelfHook];
				buildInputs = buildInputs;

				dontAutoPatchelf = false;

				unpackPhase = ''
					mkdir source
					unzip $src -d source
				'';

				installPhase = ''
					mkdir -p $out/bin
					cp source/Godot_v${if isStable then stableVersion else version}_linux.x86_64 $out/bin/godot
				'';
		 };

			godot-bin = pkgs.buildFHSUserEnv {
        name = "godot";
        targetPkgs = pkgs: buildInputs ++ [godot-unwrapped];
        runScript = "godot";
      };
in


pkgs.mkShell {
	buildInputs = [godot-bin];
	shellHook = ''exec zsh'';
	runScript = ''godot -e project.godot'';
}
	
