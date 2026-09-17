{...}: {
  # Bound the journal: 943MB accumulated on the small 120GB system SSD with
  # nothing ever reclaiming it. 512M + 7 days keeps debug history while capping
  # journald's write footprint.
  services.journald.settings.Journal = {
    SystemMaxUse = "512M";
    MaxRetentionSec = "7d";
  };
}