#!/usr/bin/env bash
set -u
set -o pipefail

AUDIO=/tmp/recording.wav
TXT=$AUDIO.txt
PIDF=$HOME/.cache/whisper-rec.pid
LOGDIR=$HOME/.cache/whisper
BIN=$HOME/whisper.cpp/build/bin/whisper-cli
MODEL=$HOME/whisper.cpp/models/ggml-base.en.bin

mkdir -p "$LOGDIR"

notify-send "🟡 Whisper" "Stopping & transcribing…"

if [[ -f $PIDF ]]; then
  kill "$(cat "$PIDF")" &>/dev/null || true
  rm -f "$PIDF"
else
  notify-send "❌ Whisper" "No recording process found"
  exit 1
fi

sleep 0.3
[[ -s $AUDIO ]] || { notify-send "⚠️ Whisper" "No audio recorded"; exit 1; }

set +e
"$BIN" -m "$MODEL" -f "$AUDIO" --output-txt &> "$LOGDIR/whisper.log"
WSTAT=$?
set -e

if [[ $WSTAT -eq 0 && -s $TXT ]]; then
  notify-send "✅ Whisper" "Transcription ready"
  if command -v wl-copy &>/dev/null; then
      wl-copy <"$TXT" || notify-send "ℹ️ Whisper" "Clipboard copy failed"
  fi
else
  notify-send "❌ Whisper" "Transcription failed"
fi

