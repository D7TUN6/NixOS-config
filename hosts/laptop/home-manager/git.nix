{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "D7TUN6";
        email = "d7tun6@gmail.com";
      };        
    };
  };
}
