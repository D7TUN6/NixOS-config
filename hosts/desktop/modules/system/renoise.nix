{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    (pkgs.renoise.override {releasePath = inputs.renoise-pkg + "/pkg.tar.gz";})
  ];
}

