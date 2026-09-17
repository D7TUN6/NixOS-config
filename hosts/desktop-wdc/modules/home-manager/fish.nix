{...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
          set -l date (date | tr 'A-Z' 'a-z')
          set -l load (awk '{print $1}' /proc/loadavg)
          set -l procs (ps -e | wc -l | xargs)
          set -l disk_info (df -h / | tail -n 1 | awk '{print $5, $2}')
          set -l disk_usage (echo $disk_info | awk '{print $1}')
          set -l disk_total (echo $disk_info | awk '{print $2}' | tr 'A-Z' 'a-z')
          set -l users (who | wc -l | xargs)
          set -l mem_total (awk '/MemTotal/ {print $2}' /proc/meminfo)
          set -l mem_free (awk '/MemFree/ {print $2}' /proc/meminfo)
          set -l mem_buffers (awk '/Buffers/ {print $2}' /proc/meminfo)
          set -l mem_cached (awk '/^Cached/ {print $2}' /proc/meminfo)
          set -l mem_used (math $mem_total - $mem_free - $mem_buffers - $mem_cached)
          set -l mem_pct (math -s0 "$mem_used / $mem_total * 100")
          set -l swap_total (awk '/SwapTotal/ {print $2}' /proc/meminfo)
          set -l swap_free (awk '/SwapFree/ {print $2}' /proc/meminfo)
          set -l swap_pct 0
          if test $swap_total -gt 0
              set -l swap_used (math $swap_total - $swap_free)
              set -l swap_pct (math -s0 "$swap_used / $swap_total * 100")
          end
          set -l ip (ip route get 1 2>/dev/null | awk '{print $7; exit}')
          set -l iface (ip route get 1 2>/dev/null | awk '{print $5; exit}')
          set -l col1_l1 (printf "system load:  %s" "$load")
          set -l col2_l1 (printf "processes:           %s" "$procs")
          set -l col1_l2 (printf "usage of /:   %s of %s" "$disk_usage" "$disk_total")
          set -l col2_l2 (printf "users logged in:     %s" "$users")
          set -l col1_l3 (printf "memory usage: %s%%" "$mem_pct")
          set -l col2_l3 (printf "ipv4 address for %s: %s" "$iface" "$ip")
          set -l col1_l4 (printf "swap usage:   %s%%" "$swap_pct")
          printf "system information as of %s\n\n" "$date"
          printf "  %-34s %s\n" "$col1_l1" "$col2_l1"
          printf "  %-34s %s\n" "$col1_l2" "$col2_l2"
          printf "  %-34s %s\n" "$col1_l3" "$col2_l3"
          printf "  %s\n" "$col1_l4"
      end
    '';
  };
}
