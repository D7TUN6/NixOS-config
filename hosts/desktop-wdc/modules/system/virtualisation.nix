{
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      qemu.swtpm.enable = true;
    };
  };
}
