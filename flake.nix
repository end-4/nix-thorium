{
  description= "Thorium using Nix Flake";
  inputs={
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }:
  {
    packages.x86_64-linux.thorium = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      name = "thorium";
      version = "120.0.6099.235 - 55";
      src = pkgs.fetchurl {
        url = "https://github.com/Alex313031/thorium/releases/download/M120.0.6099.235/Thorium_Browser_120.0.6099.235_x64.AppImage";
        sha256 = "sha256-HVqC0uk5Ia1xolLvCwDl42VXAUwkikqRasNdLOe8SUs=";
      };
      appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit name version src;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
        install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
        substituteInPlace $out/share/applications/thorium-browser.desktop \
    	  --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name} %U'
      '';
    };

    packages.x86_64-linux.default = self.packages.x86_64-linux.thorium;
    apps.x86_64-linux.thorium = {
      type = "app";
      program = "${self.packages.x86_64-linux.thorium}/bin/thorium";
    };
    apps.x86_64-linux.default = self.apps.x86_64-linux.thorium;
    # -----------------------------------------------------------
    packages.aarch64-linux.thorium = let
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      name = "thorium";
      version = "120.0.6099.235 - 5";
      src = pkgs.fetchurl {
        url = "https://github.com/Alex313031/Thorium-Raspi/releases/download/M120.0.6099.235/Thorium_Browser_120.0.6099.235_arm64.AppImage";
        sha256 = "";
      };
      appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit name version src;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
        install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
        substituteInPlace $out/share/applications/thorium-browser.desktop \
    	  --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name} %U'
      '';
    };
    packages.aarch64-linux.default = self.packages.aarch64-linux.thorium;
    apps.aarch64-linux.thorium = {
      type = "app";
      program = "${self.packages.aarch64-linux.thorium}/bin/thorium";
    };
    apps.aarch64-linux.default = self.apps.aarch64-linux.thorium;
  };
}
