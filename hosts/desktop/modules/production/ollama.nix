{
  config,
  lib,
  pkgs,
  ...
}:
let
  modelsDir = "/home/d7tun6/files/mounts/TS480SSD/models";
in {
  services.ollama = {
    enable = true;
    home = modelsDir;
    openFirewall = false;
    package = pkgs.ollama-vulkan;
  };

  systemd.services.ollama = {
    serviceConfig = {
      User = "d7tun6";
      Group = "users";
      ReadWritePaths = [modelsDir];
      PrivateTmp = lib.mkForce false;
      ProtectHome = lib.mkForce "read-only";
      DynamicUser = lib.mkForce false;
      StateDirectory = lib.mkForce [];

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      CapabilityBoundingSet = [""];
      AmbientCapabilities = [""];
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service" "~@privileged" "~@resources" "~@obsolete"];
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK"];
      MemoryDenyWriteExecute = lib.mkForce false;
      PrivateDevices = false;
      DeviceAllow = ["/dev/dri/renderD128 rw"];
      UMask = "0077";
    };
    environment = {};
    after = ["network-online.target" "home-d7tun6-files-mounts-TS480SSD.mount"];
    wants = ["network-online.target"];
    requires = ["home-d7tun6-files-mounts-TS480SSD.mount"];
  };
}
