{pkgs, ...}: {
  programs = {
    k3b.enable = true;
    kdeconnect.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
    steam.enable = true;
    niri.enable = true;
    coolercontrol.enable = true;
    virt-manager = {
      enable = true;
    };
    gphoto2.enable = true;
    fish.enable = true;
    # firefox = {
    #   enable = true;
    #   package = pkgs.firefox;
    # };
    java = {
      enable = true;
      # package = pkgs.javaPackages.compiler.temurin-bin.jre-25;
      package = pkgs.graalvmPackages.graalvm-ce;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    throne = {
      enable = true;
      tunMode.enable = true;
      package = pkgs.throne;
    };
  };
}
