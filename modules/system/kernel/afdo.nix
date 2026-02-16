{ pkgs, config, lib, ... }:

let
  vmlinux = "${config.boot.kernelPackages.kernel.dev}/vmlinux";
  llvm = pkgs.llvmPackages_22.llvm;
  destDir = "/home/lemon/nixconf/modules/hardware/kernel";
in {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "get-afdo" ''
      set -e

      echo ">> [1/4] checking environment..."
      if [ ! -f "${vmlinux}" ]; then
        echo "error: vmlinux not found."
        exit 1
      fi

      if [ ! -d "${destDir}" ]; then
        echo "error: destination directory ${destDir} not found!"
        exit 1
      fi

      echo ">> [2/4] recording perf data (600s)..."
      sudo perf record -e br_inst_retired.near_taken:k -a -b -c 1000003 -- sleep 600

      echo ">> [3/4] processing data with llvm-profgen..."
      sudo cp perf.data perf_temp.data
      sudo chown $USER:users perf_temp.data
      
      ${llvm}/bin/llvm-profgen --kernel --binary="${vmlinux}" --perfdata=perf_temp.data -o "${destDir}/kernel.afdo"

      echo ">> [4/4] cleaning up..."
      rm perf_temp.data
      
      echo "done, new profile created at: ${destDir}/kernel.afdo"
      echo "now u can run upd"
    '')
  ];
}
