{
  config,
  pkgs,
  lib,
  inputs,
  modulesPath,
  ...
}: {
  # imports = lib.pipe ./modules [
  #   lib.filesystem.listFilesRecursive
  #   (map toString)
  #   (lib.filter (lib.strings.hasSuffix ".nix"))
  # ];
    imports = lib.filter 
              (n: lib.strings.hasSuffix ".nix" n)
              (lib.filesystem.listFilesRecursive ./modules);
}
