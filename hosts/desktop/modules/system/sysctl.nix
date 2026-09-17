{lib, ...}: {
  boot.kernel.sysctl = {
    # --- Memory management ---
    # swappiness 60: prefer keeping active pages in RAM, but still move cold
    # pages to zram quickly. 100 was too aggressive — caused unnecessary I/O
    # storms during compilation. With 100% zram, cold pages compress well,
    # but hot pages must stay in RAM for latency.
    "vm.swappiness" = 60;
    # Reclaim dentries/inodes aggressively (180) — keeps RAM free for builds.
    # Files are cached in btrfs page cache; high pressure = fast reclamation
    # when nix-daemon starts a parallel build.
    "vm.vfs_cache_pressure" = 180;
    # dirty_ratio: 15% of RAM (1.1 GiB) — max dirty pages before processes
    # are forced to write back. Prevents compaction stalls during heavy
    # compilation (was 10% = 760 MiB, too low for parallel builds).
    "vm.dirty_ratio" = 15;
    # dirty_background_ratio: 5% (380 MiB) — background writeback starts
    # earlier, preventing sudden large writeback bursts. (was 3%)
    "vm.dirty_background_ratio" = 5;
    # Expire dirty pages after 30s (was 5s) — coalesce writes for SSD
    # longevity and reduce I/O during compilation hot paths.
    "vm.dirty_expire_centisecs" = 3000;
    # Writeback thread runs every 30s (was 5s) — less frequent wakeups,
    # better batching, fewer context switches during RT workloads.
    "vm.dirty_writeback_centisecs" = 3000;
    # 128 MiB emergency reserve — tuned for 8 GiB RAM. Prevents OOM during
    # memory spikes while leaving enough usable memory. (was 64 MiB)
    "vm.min_free_kbytes" = 131072;
    "vm.overcommit_ratio" = 50;
    # page-cluster 0: no readahead for swap — critical for zram latency.
    # Readahead wastes RAM and adds latency when swapping to compressed memory.
    "vm.page-cluster" = 0;
    # watermark_boost_factor: 15000 = 150× base watermark. Provides larger
    # headroom for compaction during builds — reduces stalls (was 0 = disabled).
    "vm.watermark_boost_factor" = 15000;
    # watermark_scale_factor: 50 (0.5%) — gentler background reclaim.
    # Prevents excessive kswapd wakeups while still reclaiming before OOM.
    # With zram, reclaimed pages compress well, so earlier reclaim is fine.
    "vm.watermark_scale_factor" = 50;
    # Disable proactive compaction — it causes latency spikes during builds.
    # Kernel compacts on-demand when needed for high-order allocations.
    "vm.compaction_proactiveness" = 0;

    # --- TCP keepalive (tuned for MTProto WS proxy) ---
    "net.ipv4.tcp_keepalive_time" = 30;
    "net.ipv4.tcp_keepalive_intvl" = 5;
    "net.ipv4.tcp_keepalive_probes" = 10;
    "net.ipv4.tcp_retries2" = 8;

    # --- Kernel hardening ---
    "kernel.kptr_restrict" = 2;
    "kernel.nmi_watchdog" = 0;
    # printk: console_loglevel=4 (warning+), default=4, min=4, default=4
    # Prevents notice/info messages from flooding the console (greetd TUI).
    # Errors and warnings still appear. Journal keeps all logs.
    "kernel.printk" = "4 4 4 4";
    "kernel.sysrq" = 1;
    "kernel.sched_rt_runtime_us" = 950000;
    "kernel.dmesg_restrict" = 1;
    "unprivileged_userns_clone" = 0;
    "kernel.unprivileged_bpf_disabled" = 1;

    "fs.inotify.max_user_watches" = 131072;
    "fs.file-max" = 2097152;
    "net.ipv4.ip_unprivileged_port_start" = 80;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.rmem_default" = 262144;
    "net.core.wmem_default" = 262144;
    "net.core.optmem_max" = 2048576;
    "net.ipv4.udp_rmem_min" = 16384;
    "net.ipv4.udp_wmem_min" = 16384;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.core.netdev_budget" = 600;
    "net.core.netdev_budget_usecs" = 4000;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_notsent_lowat" = 16384;
    "net.core.rmem_max" = 8388608;
    "net.core.wmem_max" = 8388608;
    "net.ipv4.tcp_rmem" = "4096 131072 8388608";
    "net.ipv4.tcp_wmem" = "4096 131072 8388608";
    "net.core.netdev_max_backlog" = 10000;
    "net.core.somaxconn" = 4096;
    "net.ipv4.tcp_max_syn_backlog" = 4096;
    "net.ipv4.tcp_adv_win_scale" = 1;
    "net.ipv4.tcp_fin_timeout" = 15;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_dsack" = 1;
    "net.ipv4.tcp_fack" = 1;
    "net.ipv4.tcp_max_tw_buckets" = 262144;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.tcp_abort_on_overflow" = 0;
    "net.ipv4.tcp_max_orphans" = 262144;
  };
}
