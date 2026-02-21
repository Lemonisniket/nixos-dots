{ pkgs, inputs, ... }:

let
  buildDeps = with pkgs; [
    gcc
    gnumake
    binutils
    flex
    bison
    pkg-config
    ncurses
    gnutar
    xz
  ];
  
  kpatch-bin = pkgs.writeShellScriptBin "kpatch" ''
    export PATH="${pkgs.lib.makeBinPath buildDeps}:$PATH"
    
    if [ -z "$1" ]; then
      echo "usage: kpatch <config_file>"
      echo "example: kpatch config"
      exit 1
    fi

    CONFIG_FILE=$(realpath "$1")
    SRC_DIR="${inputs.linux-src}"
    TMP_SRC=$(mktemp -d)

    set -e

    echo ">> unpacking kernel src from $SRC_DIR..."
    tar -xf "$SRC_DIR" -C "$TMP_SRC" --strip-components=1

    echo ">> Executing olddefconfig with $CONFIG_FILE..."
    make -C "$TMP_SRC" O="$(pwd)" KCONFIG_CONFIG="$CONFIG_FILE" olddefconfig

    echo ">> Cleaning up..."
    rm -rf "$TMP_SRC"
    rm -rf scripts include source Makefile .gitignore
    rm -f $CONFIG_FILE.old
    echo "done, updated $CONFIG_FILE is available in the current directory."
  '';
in
{
  environment.systemPackages = [ kpatch-bin ];
}
