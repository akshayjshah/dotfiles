#!/usr/bin/env bash
set -euo pipefail

playerctl -a pause || true # sometimes there's no player
swaylock
