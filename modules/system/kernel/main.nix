{ pkgs, inputs, lib, perfMode ? false, ... }:

let
  tkg-patches = "${inputs.tkg-src}/linux-tkg-patches/6.19";
  llvmPkgs = pkgs.llvmPackages_22;
  
  kConfig = if perfMode then ./conf_debug else ./config;
  kVersion = if perfMode then "6.19.0-perf-debug" else "6.19.0-tkg-bore";
  kModVersion = if perfMode then "6.19.0-perf-debug-llvm" else "6.19.0-tkg-bore-llvm";

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
  boot.kernelParams = [
    "clocksource=acpi_pm" "tsc=recalibrate" "nowatchdog" "acpi_enforce_resources=lax"
    "pci=pcie_bus_perf" "pci=noaer" "lp=0" "noserial" "8250.nr_uarts=0" "mitigations=off"
    "preempt=full" "threadirqs" "skew_tick=1" "nohz_full=1-19" "rcu_nocbs=1-19"
    "loglevel=3" "irqaffinity=8,9" "isolcpus=2-9" "rcu_nocb_poll" "intel_idle.max_cstate=0"
    "processor.max_cstate=0" "pcie_aspm=off" "pci=alloc_irq"
    "nvme_core.default_ps_max_latency=0" "nvidia-drm.modeset=1"
  ];

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
        "KCFLAGS=${lib.concatStringsSep " " (if perfMode then debugKCFlags else prodKCFlags)}"
        "KCPPFLAGS=-fno-semantic-interposition -falign-functions=32"
      ];
    });
  in pkgs.linuxPackagesFor myKernel;

  system.requiredKernelConfig = lib.mkForce [ ];
}
