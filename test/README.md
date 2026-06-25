# FFmpeg Whisper Usage Guide

This folder contains FFmpeg builds with **Whisper (automatic speech recognition)** support built in via `whisper.cpp`.

## Prerequisites

- FFmpeg binaries (`ffmpeg`, `ffprobe`) downloaded into this directory.
- A Whisper model file (e.g., `ggml-base.en.bin` or `ggml-small.en.bin`).

## List Available Models

To list models already downloaded in the current directory:

```powershell
Get-ChildItem -Filter "ggml-*.bin"
```

To browse all available models, visit:
- https://huggingface.co/ggerganov/whisper.cpp/tree/main

## Download a Whisper Model

Whisper requires a model file to run. Download one from the whisper.cpp repository:

```powershell
# Example: download the base English model
Invoke-WebRequest `
  -Uri "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin" `
  -OutFile "ggml-base.en.bin"
```

Available models:
- `ggml-tiny.en.bin` / `ggml-tiny.bin`
- `ggml-base.en.bin` / `ggml-base.bin`
- `ggml-small.en.bin` / `ggml-small.bin`
- `ggml-medium.en.bin` / `ggml-medium.bin`
- `ggml-large-v3.bin`

English-only models (`.en.bin`) are smaller and faster.

## Transcribe Audio

```powershell
# Transcribe an audio/video file to text
.\ffmpeg-windows.exe -i input.mp4 -f whisper -model_file ggml-base.en.bin -output_format txt output.txt

# Transcribe to SRT subtitles
.\ffmpeg-windows.exe -i input.mp4 -f whisper -model_file ggml-base.en.bin -output_format srt output.srt
```

## Common Whisper Options

| Option | Description |
|--------|-------------|
| `-model_file <path>` | Path to the Whisper model file |
| `-output_format <fmt>` | Output format: `txt`, `srt`, `vtt`, `lrc`, `json`, `tsv` |
| `-language <lang>` | Language code (e.g., `en`, `ja`). Auto-detected if omitted |
| `-threads <n>` | Number of threads to use |
| `-translate` | Translate speech to English |
| `-max_context <n>` | Maximum number of text context tokens |
| `-beam_size <n>` | Beam search size |

## Examples

Generate SRT subtitles from a video:
```powershell
.\ffmpeg-windows.exe -i video.mp4 -f whisper -model_file ggml-base.en.bin -output_format srt subtitles.srt
```

Transcribe with Japanese language specified:
```powershell
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language ja -output_format txt transcript.txt
```

Translate audio to English text:
```powershell
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -translate -output_format txt translation.txt
```

### Vietnamese, Chinese, and Japanese

Use the multilingual (non-`.en`) model for best results with these languages.

**Vietnamese (Tiếng Việt)**:
```powershell
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language vi -output_format txt vietnamese.txt
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language vi -output_format srt vietnamese.srt
```

**Chinese (中文)**:
```powershell
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language zh -output_format txt chinese.txt
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language zh -output_format srt chinese.srt
```

**Japanese (日本語)**:
```powershell
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language ja -output_format txt japanese.txt
.\ffmpeg-windows.exe -i audio.wav -f whisper -model_file ggml-base.bin -language ja -output_format srt japanese.srt
```

For multi-language content, omit `-language` to let Whisper auto-detect:
```powershell
.\ffmpeg-windows.exe -i mixed.wav -f whisper -model_file ggml-base.bin -output_format srt mixed.srt
```

## Notes

- First run may take longer as the model is loaded into memory.
- Use smaller models (tiny/base) for faster inference and lower accuracy, or larger models (medium/large) for better accuracy at the cost of speed.
- Whisper is auto-detected during the FFmpeg build if `whisper.cpp` is available on the build system.
