{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  time.timeZone = "Asia/Yekaterinburg";
  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "ru_RU.UTF-8";
    };
  };
}
