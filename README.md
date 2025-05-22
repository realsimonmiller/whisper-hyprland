# Whisper-on-Hyprland

Local speech-to-text (OpenAI Whisper) triggered by **Alt + Space**.

| What | Details |
|------|---------|
| Model | `ggml-base.en.bin` (142 MB, English-only, ~3 s cold start) |
| Hotkey | **Hold Alt + Space** → record; **release** → transcribe |
| Output | Transcript saved to `/tmp/recording.wav.txt` + copied to clipboard |

## Install

```bash
git clone https://github.com/username/whisper-hyprland.git
cd whisper-hyprland
./install.sh

