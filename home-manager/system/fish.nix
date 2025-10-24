{
  config,
  libs,
  packages,
  inputs,
  ...
}: {
  programs.fish = {
    # Enable fish.
    enable = true;

    # Set interactive shell init parameters.
    interactiveShellInit = ''
      # Disable greeting.
      set fish_greeting
      # if status is-login
      #     if test -z "$DISPLAY" -a "$(tty)" = /dev/tty1
      #         niri-session
      #     end
      # end
    '';
  };
}
