#!/usr/bin/env bash
# One-shot installer for Arch + Hyprland

set -euo pipefail
echo "==> Installing dependencies…"
sudo pacman -Sy --needed --noconfirm git base-devel ffmpeg wl-clipboard libnotify

echo "==> Cloning & building whisper.cpp…"
if [[ ! -d $HOME/whisper.cpp ]]; then
  git clone https://github.com/ggerganov/whisper.cpp.git "$HOME/whisper.cpp"
fi
cmake -S "$HOME/whisper.cpp" -B "$HOME/whisper.cpp/build" -DCMAKE_BUILD_TYPE=Release
cmake --build "$HOME/whisper.cpp/build" --config Release --parallel "$(nproc)"

echo "==> Downloading English base model…"
bash "$HOME/whisper.cpp/models/download-ggml-model.sh" base.en

echo "==> Installing helper scripts…"
mkdir -p "$HOME/scripts"
cp scripts/whisper-start.sh scripts/whisper-stop.sh "$HOME/scripts/"
chmod +x "$HOME/scripts/"whisper-*.sh

echo "==> Adding Hyprland key-bindings (Alt+Space)…"
CONF="$HOME/.config/hypr/hyprland.conf"
grep -q "whisper-start.sh" "$CONF" 2>/dev/null || {
  cat >>"$CONF" <<'EOF'

# Whisper dictation bindings
bind  = ALT, SPACE, exec, ~/scripts/whisper-start.sh
bindr = ALT, SPACE, exec, ~/scripts/whisper-stop.sh
EOF
}

echo "==> Done.  Reload Hyprland with:  hyprctl reload"

