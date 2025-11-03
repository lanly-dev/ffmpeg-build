# FFmpeg Monthly Prebuilt Binaries

This repository automates building FFmpeg from upstream once a month for Windows, Linux, and macOS using GitHub Actions.

- Source: https://github.com/FFmpeg/FFmpeg (official mirror)
- Schedule: Runs on the 1st of every month at 00:00 UTC (and can be triggered manually)
- Output: Standalone binaries (`ffmpeg` and `ffprobe`) for each OS
- Release: A GitHub Release is created per run with all platform assets

> **Need more build options?** Check out [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) for comprehensive FFmpeg builds with GPL codecs, various linking options, and more configurations.

## What gets built
These builds include **GPL codecs and GPU acceleration support**, making them feature-rich and redistributable under GPL v3.

**Included features:**
- **Video Codecs:** x264 (H.264), x265 (H.265/HEVC), VP8/VP9 (WebM)
- **Audio Codecs:** Opus, Vorbis
- **Image Formats:** GIF (built-in support)
- **AI/ML:** Whisper (automatic speech recognition - if detected, requires model files)
- **GPU acceleration:**
  - **NVIDIA**: NVENC/NVDEC (all platforms - uses ffnvcodec headers, GPL-compatible)
  - **AMD**: AMF (Windows)
  - **Intel/AMD**: VAAPI (Linux)
  - **Apple**: VideoToolbox (macOS)

**Build configuration:**
- **Linux**: Static build with GPL codecs, VAAPI, and NVENC/NVDEC (Intel/AMD/NVIDIA GPU acceleration)
- **macOS**: Static build with GPL codecs and VideoToolbox (Apple GPU acceleration)
- **Windows**: Static build with GPL codecs, NVENC, NVDEC, and AMF (NVIDIA/AMD GPU acceleration) - no runtime DLLs


## How it works
1. Resolve latest upstream FFmpeg tag (like `n7.1`) via GitHub API
2. Build on a 3-OS matrix with static linking
3. Upload flat artifacts (binaries only, no nested folders or zips)
4. Publish a GitHub Release with renamed assets per OS

## Manual run
You can manually dispatch the workflow from the Actions tab. Optionally override the FFmpeg ref (tag or commit SHA).

## Release assets
Each release includes:
- `ffmpeg-linux` / `ffprobe-linux`
- `ffmpeg-macos` / `ffprobe-macos`
- `ffmpeg-windows.exe` / `ffprobe-windows.exe`

All binaries are standalone with no external dependencies.

## Licensing

See https://ffmpeg.org/legal.html for full FFmpeg licensing details.

## Customization
To modify codecs or features, edit `.github/workflows/build-and-release.yml` and adjust the `./configure` flags per OS.
