# FFmpeg Monthly Prebuilt Binaries

This repository automates building FFmpeg from upstream once a month for Windows, Linux, and macOS using GitHub Actions.

- Source: https://github.com/FFmpeg/FFmpeg (official mirror)
- Schedule: Runs on the 1st of every month at 00:00 UTC (and can be triggered manually)
- Output: Zipped artifacts per OS containing `ffmpeg` and `ffprobe` binaries, plus build metadata
- Release: A GitHub Release is created per run with all platform assets

## What gets built
By default, this builds FFmpeg with built-in codecs only (no external libraries. This keeps builds portable and licensing straightforward. You can customize the `./configure` flags in the workflow to enable more libraries if needed.

Notes:
- Linux: static build (reduced runtime deps)
- Windows: MSYS2 toolchain, static build by default
- macOS: shared build (static linking is limited on macOS)

## How it works
1. Resolve latest upstream FFmpeg tag (like `n7.1`) via GitHub API
2. Build on a 3-OS matrix
3. Package outputs as zip archives
4. Publish a GitHub Release with all assets

## Manual run
You can manually dispatch the workflow from the Actions tab. Optionally override the FFmpeg ref (tag or commit SHA).

## Artifacts naming
- `ffmpeg-<ref>-<os>-x86_64.zip`

Each archive includes:
- `bin/ffmpeg[.exe]`
- `bin/ffprobe[.exe]`
- `LICENSES/` (FFmpeg licensing files)
- `BUILD-INFO.json` (upstream ref, build date, configure flags)

## Customize configure flags
Edit `.github/workflows/build-and-release.yml` and adjust the `./configure` commands per OS.

## Troubleshooting
- Windows builds can be slower due to toolchain bootstrap. If timing out, reduce features or use smaller runners.
- If the upstream tag has't changed since last month, this still produces a new dated release. You can change the release tag pattern if you prefer otherwise.
