{...}: {
  systemd.tmpfiles.rules = [
    "w! /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 2000"
    "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
    "L+ /var/lib/dbus/machine-id - - - - /etc/machine-id"
  ];
}

