{ lib, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd = {
    includeDefaultModules = false;
    checkJournalingFS = false;
    availableKernelModules = lib.mkForce [];
    kernelModules = lib.mkForce [];
    systemd.enable = true;
    supportedFilesystems = lib.mkForce [ "btrfs" ];
  };

  boot.kernelParams = [
    "clocksource=acpi_pm" "tsc=recalibrate" "nowatchdog" "acpi_enforce_resources=lax"
    "pci=pcie_bus_perf" "pci=noaer" "lp=0" "noserial" "8250.nr_uarts=0" "mitigations=off"
    "preempt=full" "threadirqs" "skew_tick=1" "nohz_full=1-19" "rcu_nocbs=1-19"
    "loglevel=3" "irqaffinity=8,9" "isolcpus=2-9" "rcu_nocb_poll" "intel_idle.max_cstate=0"
    "processor.max_cstate=0" "pcie_aspm=off" "pci=alloc_irq"
    "nvme_core.default_ps_max_latency=0" "nvidia-drm.modeset=1"
  ];
}
