# FFmpeg Monthly Prebuilt Binaries

This repository automates building FFmpeg from upstream once a month for Windows, Linux, and macOS using GitHub Actions.

- Source: https://github.com/FFmpeg/FFmpeg (official mirror)
- Schedule: Runs on the 1st of every month at 00:00 UTC (and can be triggered manually)
- Output: Standalone binaries (`ffmpeg` and `ffprobe`) for each OS
- Release: A GitHub Release is created per run with all platform assets

> **Need more build options?** Check out [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) for comprehensive FFmpeg builds with GPL codecs, various linking options, and more configurations.

## What gets built
These builds use FFmpeg's built-in codecs only (LGPL v2.1+), with no external GPL libraries like libx264/libx265. This keeps builds portable, licensing straightforward, and ensures no external runtime dependencies.

Build configuration:
- **Linux**: Fully static (musl-based, no glibc dependency)
- **Windows**: Static build with no runtime DLLs (MSYS2 toolchain)
- **macOS**: Static FFmpeg libraries (system frameworks remain dynamic)

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
These builds are licensed under **LGPL v2.1+** (built-in codecs only, no GPL or nonfree components). You can use these binaries in commercial or closed-source projects as long as you:
1. Provide attribution to FFmpeg
2. Link to the LGPL license
3. Allow users to replace the FFmpeg binaries with their own versions

See https://ffmpeg.org/legal.html for full details.

## Customization
To enable additional codecs or features, edit `.github/workflows/build-and-release.yml` and adjust the `./configure` flags per OS. Note that adding GPL libraries (like libx264/libx265) will change the license to GPL v2+.
