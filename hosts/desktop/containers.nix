{lib, ...}: {
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    containers = {
      registries.settings = {
        registries = {
          search.registries = ["docker.io" "quay.io"];
        };
      };
    };
    oci-containers = {
      backend = "podman";
    };
  };

  imports =
    lib.filter
    (n: lib.strings.hasSuffix ".nix" n)
    (lib.filesystem.listFilesRecursive ./modules/containers);
}