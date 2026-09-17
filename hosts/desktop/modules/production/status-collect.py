import json
import os
import subprocess
import sys
import time
from datetime import datetime

UNITS = [
    ("telegram-bot-api.service", "bots"),
    ("blogbot.service", "bots"),
    ("blurt-bot.service", "bots"),
    ("markov-bot.service", "bots"),
    ("pidorbot.service", "bots"),
    ("pivometr.service", "bots"),
    ("bot-shakalizator.service", "bots"),
    ("combox-backend.service", "combox"),
    ("combox-frontend.service", "combox"),
    ("combox-resend-proxy.service", "combox"),
    ("podman-nginx.service", "combox"),
    ("podman-anubis-app.service", "combox"),
    ("podman-anubis-site.service", "combox"),
    ("podman-postgres.service", "combox"),
    ("podman-valkey.service", "combox"),
    ("podman-minio.service", "combox"),
    ("podman-pgweb.service", "combox"),
    ("lazymc.service", "minecraft"),
    ("minecraft.service", "minecraft"),
    ("podman-qbittorrent.service", "media"),
    ("podman-net-agent.service", "media"),
    ("podman-qbitwebui.service", "media"),
    ("caddy.service", "edge"),
    ("podman-tg-ws-proxy.service", "edge"),
    ("container@tor-gateway.service", "edge"),
    ("xray.service", "edge"),
    ("ollama.service", "ai"),
    ("redis-d7tun6.service", "data"),
    ("d7tun6-icecast.service", "radio"),
    ("d7tun6-liquidsoap.service", "radio"),
]

PROPS = [
    "Names",
    "LoadState",
    "ActiveState",
    "SubState",
    "ActiveEnterTimestamp",
    "ActiveEnterTimestampMonotonic",
]


def sysctl(unit):
    proc = subprocess.run(
        ["systemctl", "show", unit, "--no-pager", "--quiet", "--property=" + ",".join(PROPS)],
        capture_output=True,
        text=True,
    )
    out = {}
    for line in proc.stdout.splitlines():
        if "=" in line:
            k, _, v = line.partition("=")
            out[k] = v
    return out


def classify(active, sub, load):
    if active == "active" and sub == "running":
        return "up"
    if active == "failed":
        return "error"
    if active in ("activating", "deactivating", "reloading"):
        return "error"
    if active == "active" and sub in ("auto-restart", "exited", "wait"):
        return "error"
    if load == "not-found":
        return "down"
    return "down"


def parse_real_ts(s):
    s = s.strip()
    if not s:
        return None
    try:
        return datetime.strptime(s, "%a %Y-%m-%d %H:%M:%S %z").timestamp()
    except ValueError:
        return None


def pretty_name(unit):
    base = unit[: -len(".service")] if unit.endswith(".service") else unit
    base = base.replace("podman-", "")
    base = base.replace("container@", "")
    base = base.replace("-d7tun6", "")
    base = base.replace("bot-shakalizator", "shakalizator")
    base = base.replace("combox-resend-proxy", "resend proxy")
    base = base.replace("combox-backend", "backend")
    base = base.replace("combox-frontend", "frontend")
    base = base.replace("d7tun6-icecast", "icecast")
    base = base.replace("d7tun6-liquidsoap", "liquidsoap")
    return base


def main():
    out_path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/production-status.json"
    now_mono = time.monotonic()
    try:
        with open("/proc/uptime", "r") as fh:
            host_uptime = round(float(fh.read().split()[0]))
    except Exception:
        host_uptime = 0

    services = []
    for unit, group in UNITS:
        props = sysctl(unit)
        active = props.get("ActiveState", "")
        sub = props.get("SubState", "")
        load = props.get("LoadState", "")

        uptime = 0
        try:
            mono_us = int(props.get("ActiveEnterTimestampMonotonic", ""))
        except ValueError:
            mono_us = 0
        if mono_us > 0:
            uptime = max(0, int(now_mono - mono_us / 1e6))
        else:
            ts = parse_real_ts(props.get("ActiveEnterTimestamp", ""))
            if ts:
                uptime = max(0, int(time.time() - ts))

        services.append(
            {
                "id": unit,
                "name": pretty_name(unit),
                "group": group,
                "state": classify(active, sub, load),
                "activeState": active,
                "subState": sub,
                "uptimeSec": uptime,
            }
        )

    payload = {
        "ok": True,
        "generatedAt": int(time.time() * 1000),
        "hostUptimeSec": host_uptime,
        "services": services,
    }

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    tmp = out_path + ".tmp"
    with open(tmp, "w") as fh:
        json.dump(payload, fh, indent=2)
    os.replace(tmp, out_path)
    os.chmod(out_path, 0o644)
    print(f"wrote {out_path} ({len(services)} services)")


if __name__ == "__main__":
    main()