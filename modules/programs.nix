{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    ssh = {
      askPassword = lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    };
    chromium = {
      enable = true;
      extensions = [
        "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx" # Dark Reader
        "aapbdbdomjkkjkaonfhkkikfgjllcleb;https://clients2.google.com/service/update2/crx" # Google Translate
        # "ohahllgiabjaoigichmmfljhkcfikeof;https://clients2.google.com/service/update2/crx" # AdBlocker Ultimate
        # "bgnkhhnnamicmpeenaelnjfhikgbkllg;https://clients2.google.com/service/update2/crx" # Adguard Antibanner
        # "epcnnfbjfcgphgdmggkamkmgojdagdnn;https://clients2.google.com/service/update2/crx" # uBlock
        # "bbdpgcaljkaaigfcomhidmneffjjjfgp;https://clients2.google.com/service/update2/crx" # uBlock Origin Scope
        # "hhdobjgopfphlmjbmnpglhfcgppchgje;https://clients2.google.com/service/update2/crx" # AdGuard VPN
        # "akcocjjpkmlniicdeemdceeajlmoabhg;https://clients2.google.com/service/update2/crx" # 1VPN
        # "olnbjpaejebpnokblkepbphhembdicik;https://clients2.google.com/service/update2/crx" # WebGL Fingerprint Defender
        # "lanfdkkpgfjfdikkncbnojekcppdebfp;https://clients2.google.com/service/update2/crx" # Canvas Fingerprint Defender
        # "nomnklagbgmgghhjidfhnoelnjfndfpd;https://clients2.google.com/service/update2/crx" # Canvas Blocker - Fingerprint Protect
        # "ldpochfccmkkmhdbclfhpagapcfdljkj;https://clients2.google.com/service/update2/crx" # Decentraleyes
        # "mlomiejdfkolichcflejclcbmpeaniij;https://clients2.google.com/service/update2/crx" # Ghostery
        # "jfnangjojcioomickmmnfmiadkfhcdmd;https://clients2.google.com/service/update2/crx" # NoMiner
        # "ihcjicgdanjaechkgeegckofjjedodee;https://clients2.google.com/service/update2/crx" # Malwarebytes Browser Guard
        # "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;https://clients2.google.com/service/update2/crx" # Privacy Badger
        # "mnjggcdmjocbbbhaepdhchncahnbgone;https://clients2.google.com/service/update2/crx" # SponsorBlock
      ];
    };
    amnezia-vpn = {
      enable = true;
    };
    niri = {
      enable = true;
    };
    virt-manager.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk21;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraPackages = [ pkgs.jdk ];
    };
    direnv.enable = true;
    nekoray = {
      enable = true;
      tunMode.enable = true;
    };
    fish = {
      enable = true;
    };
  };
}
