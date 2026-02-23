{ pkgs, inputs, lib, perfMode ? false, ... }:

let
  getVersion = src: 
    let
      makefile = builtins.readFile "${src}/Makefile";
      parse = name: (builtins.match ".*${name} = ([0-9]+).*" makefile);
      major = builtins.head (parse "VERSION");
      patch = builtins.head (parse "PATCHLEVEL");
      sub = builtins.head (parse "SUBLEVEL");
    in "${major}.${patch}.${sub}";

  actualVersion = getVersion inputs.linux-src;
  
  tkg-patches = "${inputs.tkg-src}/linux-tkg-patches/6.19";
  llvmPkgs = pkgs.llvmPackages_22;
  
  kConfig = if perfMode then ./config else ./conf_debug;
  
  suffix = if perfMode then "-tkg-bore" else "-perf-debug";
  kVersion = "${actualVersion}${suffix}";
  kModVersion = "${kVersion}-llvm";

  prodKCFlags = [
    "-march=ivybridge" "-O3" "-fprofile-sample-use=${./kernel.afdo}"
    "-fprofile-sample-accurate" "-falign-functions=32" "-mllvm --polly"
    "-mllvm --polly-vectorizer=stripmine" "-mllvm --polly-invariant-load-hoisting"
    "-mllvm --polly-run-inliner" "-mllvm --inline-threshold=400"
    "-mllvm --extra-vectorizer-passes" "-mllvm --pgo-warn-missing-function" "-fno-common"
  ];

  debugKCFlags = [
    "-march=ivybridge" "-O2" "-fno-omit-frame-pointer" "-falign-functions=32"
  ];

in {
  boot.kernelPackages = let
    clangStdenv = pkgs.overrideCC llvmPkgs.stdenv llvmPkgs.clang;
    myKernel = (pkgs.linuxKernel.manualConfig {
      stdenv = clangStdenv;
      src = inputs.linux-src;
      version = kVersion;
      modDirVersion = kModVersion;
      configfile = kConfig;
      kernelPatches = [
        { name = "bore"; patch = "${tkg-patches}/0001-bore.patch"; }
        { name = "misc"; patch = "${tkg-patches}/0012-misc-additions.patch"; }
      ];
    }).overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.lz4 llvmPkgs.llvm llvmPkgs.lld ];
      prePatch = (old.prePatch or "") + ''
        export CCACHE_DIR=/var/cache/ccache
        export CCACHE_UMASK=007
        export CCACHE_SLOPPINESS=include_file_mtime,pch_defines,time_macros
      '';
      makeFlags = (old.makeFlags or []) ++ [
        "LLVM=1" "LLVM_IAS=1" "-j20"
        "KCFLAGS=${lib.concatStringsSep " " (if perfMode then prodKCFlags else debugKCFlags)}"
        "KCPPFLAGS=-fno-semantic-interposition -falign-functions=32"
      ];
    });
  in pkgs.linuxPackagesFor myKernel;

  system.requiredKernelConfig = lib.mkForce [ ];
}
