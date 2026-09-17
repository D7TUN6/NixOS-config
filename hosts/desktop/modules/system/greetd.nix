{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # --time      — show clock
        # --remember  — remember last selected session
        # --cmd       — default session command
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
