{lib, inputs, ...}: {
  imports =
    lib.filter
    (n: lib.strings.hasSuffix ".nix" n)
    (lib.filesystem.listFilesRecursive ./modules/system);
}
