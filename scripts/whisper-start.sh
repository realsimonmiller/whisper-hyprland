#!/usr/bin/env bash
# Starts mic recording (Pulse/PipeWire) until killed; saves PID.

set -euo pipefail
AUDIO=/tmp/recording.wav
PIDF=$HOME/.cache/whisper-rec.pid
mkdir -p "$(dirname "$PIDF")"

notify-send "🟢 Whisper" "Recording started…"

# Kill existing recorder if any
pkill -f "ffmpeg -f pulse -i" 2>/dev/null || true
rm -f "$AUDIO" "$AUDIO.txt" "$PIDF"

ffmpeg -f pulse -i default -y "$AUDIO" &> ~/.cache/whisper/rec.log &
echo $! > "$PIDF"

