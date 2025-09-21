{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  time.timeZone = "Asia/Yekaterinburg";
  i18n.defaultLocale = "en_US.UTF-8";
}
