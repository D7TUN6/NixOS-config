{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (pkgs.renoise.override {releasePath = ../../smth/secrets/renoise/pkg.tar.gz;})
  ];
}

