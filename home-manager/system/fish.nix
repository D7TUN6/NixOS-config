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
    '';
  };
}
