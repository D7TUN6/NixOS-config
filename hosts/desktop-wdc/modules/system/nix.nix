{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    optimise = {
      automatic = true;
      dates = "06:00";
    };
    settings = {
      auto-optimise-store = false;
      allowed-users = ["d7tun6" "root"];
      experimental-features = ["nix-command" "flakes"];
      extra-deprecated-features = ["or-as-identifier"];
    };
    gc = {
      automatic = true;
      dates = "04:00";
      randomizedDelaySec = "45min";
    };
  };
}
