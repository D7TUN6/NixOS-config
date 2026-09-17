{
  lib,
  pkgs,
  ...
}: {
  services = {
    tor = {
      enable = true;
      client = {
        enable = true;
        dns.enable = true;
      };

      settings = {
        # DNSPort = [
        #   {
        #     addr = "127.0.0.1";
        #     port = 53;
        #   }
        # ];
        UseBridges = 1;
        ClientTransportPlugin = "webtunnel exec ${pkgs.webtunnel}/bin/client";
        SocksPort = "0.0.0.0:9051";
        Bridge = [
          "webtunnel [2001:db8:191d:f879:307f:ae5f:f25f:edbe]:443 E8F3D7D70ECDD1441B09958B04EABB835F7E7C4F url=https://cdn-130.triplebit.dev/3b4c2d5e6f7g8h9i0j1k2l3m ver=0.0.2"
          "webtunnel [2001:db8:1da7:e44a:892b:6ada:b3e2:4160]:443 ACBB486B9D60979A05E623D11CC8181A16A81E51 url=https://usa.bulger.au/7gBqm1jbTOpU0jLV91IZHN0f ver=0.0.1"
        ];
      };
    };

    privoxy = {
      enable = true;
      settings = {
        listen-address = "0.0.0.0:8118";
        forward-socks5t = "/ 127.0.0.1:9051 .";
      };
    };

    # thermald.enable = true;
    udisks2.enable = true;
  };
}
