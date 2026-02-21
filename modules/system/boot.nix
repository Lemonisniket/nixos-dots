{ lib, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.timeout = 1;

  boot.initrd = {
    enable = true;
    systemd.enable = true;
    includeDefaultModules = false;
    availableKernelModules = lib.mkForce [ "bcachefs" ];
    checkJournalingFS = false;
    kernelModules = lib.mkForce [];
    supportedFilesystems = lib.mkForce [ "bcachefs" ]; 
    services.lvm.enable = false;
    compressor = "zstd";
    compressorArgs = [ "-19" ]; 
  };

  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelParams = [
    "nowatchdog" "acpi_enforce_resources=lax" "idle=mwait" "bcachefs.metadata_replicas=1"
    "pci=pcie_bus_perf" "pci=noaer" "preempt=voluntary" "skew_tick=1"  "mitigations=off"
    "loglevel=3" "intel_idle.max_cstate=1" "root=/dev/nvme0n1p2"
    "rootwait" "processor.max_cstate=1" "pcie_aspm=off" "clearcpuid=229"
    "nvidia-drm.modeset=1" "nvme_core.default_ps_max_latency=0" "lpj=5587210"
    ];
}
