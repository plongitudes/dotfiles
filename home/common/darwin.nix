# Mac-only pieces of the common profile. Imported unconditionally from
# default.nix; the body is mkIf-gated so the same module is a no-op on the
# NixOS VM. Separate file rather than `++ lib.optionals stdenv.isDarwin` inline
# in default.nix because alejandra re-indents an entire list the moment a
# binary operator follows it — a 150-line whitespace diff for one package.
{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [
      # blueutil — Bluetooth CLI, called from the Hammerspoon config (below) to
      # release a device on lock/sleep. From Nix rather than brew so the Lua can
      # reference an exact store path. Darwin-only in nixpkgs, which is why this
      # whole module is gated: an ungated reference would fail eval on the VM.
      pkgs.blueutil
    ];

    # Hammerspoon (brew cask — see bootstrap.sh; it's a .app bundle and not in
    # nixpkgs) reads ~/.hammerspoon/init.lua. In-store copy like btop, file not
    # dir, so ~/.hammerspoon/Spoons/ stays writable if a Spoon is ever installed.
    # Edits: repo + `switch` + Hammerspoon menu → Reload Config. The Lua calls
    # blueutil by exact store path — `@blueutil@` is substituted here — for the
    # same reason as the neovide config in default.nix: a Finder-launched app
    # has no ~/.nix-profile on PATH.
    home.file.".hammerspoon/init.lua".source = pkgs.replaceVars ../../config/hammerspoon/init.lua {
      blueutil = "${pkgs.blueutil}/bin/blueutil";
    };
  };
}
