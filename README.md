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
```



### Key-binding

`install.sh` automatically appends these lines to  
`~/.config/hypr/hyprland.conf` (if they’re not already there):

```ini
bind  = ALT, SPACE, exec, ~/scripts/whisper-start.sh
bindr = ALT, SPACE, exec, ~/scripts/whisper-stop.sh
```


## Switching Models with `modelctl`

`modelctl` is installed by `install.sh` and makes it trivial to try
different Whisper models.

| Command | What it does |
|---------|--------------|
| `modelctl list` | Show all models already in `~/whisper.cpp/models` and which one is active. |
| `modelctl dl <name>` | Download a model if you don’t have it yet (wraps Whisper-cpp’s helper script). Examples:<br>`modelctl dl small.en`  `modelctl dl medium-q5_0` |
| `modelctl use <name>` | Point the symlink `ggml-current.bin` at that model. Takes effect immediately—no script edit or Hyprland reload needed. |

### Example workflow

```bash
# see what you have
modelctl list

# download the quantized medium model (≈ 900 MB)
modelctl dl medium-q5_0

# start using it right away
modelctl use medium-q5_0

# too heavy? switch back to English small
modelctl dl small.en          # first time only
modelctl use small.en
