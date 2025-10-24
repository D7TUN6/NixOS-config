{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    ssh = {
      askPassword = lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    };
    niri = {
      enable = true;
    };
    virt-manager.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk21;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraPackages = [ pkgs.jdk ];
    };
    direnv.enable = true;
    nekoray = {
      enable = true;
      tunMode.enable = true;
    };
    fish = {
      enable = true;
    };
  };
}
