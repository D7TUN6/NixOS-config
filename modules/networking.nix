{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "PC";
    enableIPv6 = true;
    hostId = lib.mkDefault "8425e349";
    useDHCP = lib.mkDefault true;
    interfaces.eth0.useDHCP = lib.mkDefault true;
    nat.enable = true;
    networkmanager = {
      enable = true;
      dns = "none";
      insertNameservers = [
        # Cloudflare.
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        # Google.
        "8.8.8.8"
        "8.8.4.4"
        "2001:4860:4860::8888"
        "2001:4860:4860::8844"
        "8.8.8.8#dns.google"
        "8.8.4.4#dns.google"
        # Quad 9.
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
    };
      nameservers = [
        # Cloudflare.
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        # Google.
        "8.8.8.8"
        "8.8.4.4"
        "2001:4860:4860::8888"
        "2001:4860:4860::8844"
        "8.8.8.8#dns.google"
        "8.8.4.4#dns.google"
        # Quad 9.
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
        "9.9.9.9#dns.quad9.net"
        "149.112.112#112:dns.quad9.net"
      ];
    firewall = {
      enable = false;
      allowedTCPPorts = [
        17011 # Wormnet.
        21001 # SSH.
        9050 # TOR.
        9063
        9001
        9051
        
      ];
      allowedUDPPorts = [
        17011 # Wormnet.
        21001 # SSH.
        9050 # TOR.
        9063
        9001
        9051
      ];
    };
  };
}
