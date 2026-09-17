{
  lib,
  ...
}: {
  services.openssh = {
    enable = false;
    openFirewall = true;
    ports = [21435];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = ["d7tun6"];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
}

