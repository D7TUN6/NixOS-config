# Contents of minecraft-vm.nix
{ config, pkgs, ... }:
{
  # Bootloader is required for the VM
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable SSH for remote access into the VM
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true; # For initial setup; consider keys for better security
  };

  # Create a user to log into via SSH
  users.users.server = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "1590"; # Change this immediately after login
  };

  # Enable and configure the Minecraft server
  nixpkgs.config.allowUnfree = true;
  services.minecraft-server = {
    enable = true;
    eula = true;
  };

  # Set a system state version
  system.stateVersion = "25.05";
}
