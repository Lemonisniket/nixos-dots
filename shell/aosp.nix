{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "aosp-build-env";
  targetPkgs = pkgs: with pkgs; [
    bc
    binutils
    bison
    ccache
    curl
    flex
    gcc
    git
    git-lfs
    gnupg
    gperf
    imagemagick
    libxml2
    lz4
    lzop
    nettools
    ninja
    openssl
    openssl.dev
    optipng
    perl
    pngcrush
    procps
    rsync
    schedtool
    squashfsTools
    unzip
    util-linux
    wget
    zip
    zlib
    zsh
    zstd
    lz4
    lzo
    gzip
    unzip
    libelf
    libxcrypt-legacy

    python3
    python3Packages.protobuf
    
    clang
    cmake
    gnumake
    protobuf
    
    glibc.dev
    glibc.static
    ncurses5
    libxcrypt
    libelf
    expat
    
    stdenv.cc.libc
    stdenv.cc.libc_dev
    stdenv.cc.cc
    pkg-config
    ncurses
    libxslt
    
    jdk11
  ];

  multiPkgs = pkgs: with pkgs; [
    zlib
    readline
    ncurses5
  ];

profile = ''
    export GCC_EXEC_PREFIX="/usr/lib/gcc/"
    
    export C_INCLUDE_PATH="/usr/include:$C_INCLUDE_PATH"
    export CPLUS_INCLUDE_PATH="/usr/include:$CPLUS_INCLUDE_PATH"
    export LIBRARY_PATH="/usr/lib:/usr/lib64:$LIBRARY_PATH"

    if [ -d "$HOME/platform-tools" ] ; then
      export PATH="$HOME/platform-tools:$PATH"
    fi
    
    export USE_CCACHE=1
    export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
  '';

  runScript = "zsh";
})
