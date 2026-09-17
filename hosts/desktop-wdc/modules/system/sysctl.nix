{lib, ...}: {
  boot.kernel.sysctl = {
    "net.ipv4.tcp_keepalive_time" = 60;
    "net.ipv4.tcp_keepalive_intvl" = 10;
    "net.ipv4.tcp_keepalive_probes" = 6;
    "net.ipv4.tcp_retries2" = 5;

    "kernel.kptr_restrict" = 2;
    "kernel.nmi_watchdog" = 0;
    "kernel.printk" = "3 3 3 3";
    "kernel.sysrq" = 1;
    "kernel.sched_rt_runtime_us" = 950000;

    "vm.swappiness" = 1;
    "vm.vfs_cache_pressure" = 100;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_expire_centisecs" = 500;
    "vm.dirty_writeback_centisecs" = 500;
    "vm.min_free_kbytes" = 65536;
    "vm.overcommit_ratio" = 50;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 150;
    "vm.compaction_proactiveness" = 0;

    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
    "net.ipv4.ip_unprivileged_port_start" = 80;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.rmem_default" = 1048576;
    "net.core.wmem_default" = 1048576;
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
  };
}
