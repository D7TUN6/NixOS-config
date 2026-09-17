{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    optimise = {
      automatic = true;
      dates = "Sat 06:00";
    };
    settings = {
      auto-optimise-store = false;
      allowed-users = ["d7tun6" "root"];
      experimental-features = ["nix-command" "flakes"];
      max-jobs = 13;
      keep-outputs = true;
      keep-derivations = true;
      fallback = true;
    };
    gc = {
      automatic = true;
      dates = "04:00";
      randomizedDelaySec = "45min";
    };
  };
}
