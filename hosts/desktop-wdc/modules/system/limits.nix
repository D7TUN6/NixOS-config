{
  lib,
  ...
}: {
  systemd.services."container@jellyfin".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "2G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@xray".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "2G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@navidrome".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "2G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@syncthing".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "2G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@vaultwarden".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "2G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
}

