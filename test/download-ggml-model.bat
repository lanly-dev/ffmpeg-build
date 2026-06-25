@echo off
setlocal enabledelayedexpansion

set "src=https://huggingface.co/ggerganov/whisper.cpp"
set "pfx=resolve/main/ggml"

set "BOLD=^&echo."
set "RESET="

:: Get script directory
set "script_path=%~dp0"
set "script_path=%script_path:~0,-1%"

:: Check if running from /bin directory
echo %script_path% | findstr /i "\\bin$" >nul
if %errorlevel%==0 (
    set "default_download_path=%cd%"
) else (
    set "default_download_path=%script_path%"
)

:: Get download directory from argument or default
if "%~2"=="" (
    set "download_dir=%default_download_path%"
) else (
    set "download_dir=%~2"
)

:: Whisper models
set "models= tiny tiny.en tiny-q5_1 tiny.en-q5_1 tiny-q8_0 base base.en base-q5_1 base.en-q5_1 base-q8_0 small small.en small.en-tdrz small-q5_1 small.en-q5_1 small-q8_0 medium medium.en medium-q5_0 medium.en-q5_0 medium-q8_0 large-v1 large-v2 large-v2-q5_0 large-v2-q8_0 large-v3 large-v3-q5_0 large-v3-turbo large-v3-turbo-q5_0 large-v3-turbo-q8_0 "

:: Check arguments
if "%~1"=="" (
    echo.
    echo Usage: %~nx0 ^<model^> [download_dir]
    echo.
    call :list_models
    echo ___________________________________________________________
    echo .en ^= english-only -q5_[01] ^= quantized -tdrz ^= tinydiarize
    echo.
    exit /b 1
)

set "model=%~1"

echo %models% | findstr /i /c:" %model% " >nul
set "model_valid=%errorlevel%"

if %model_valid%==1 (
    echo Invalid model: %model%
    echo.
    call :list_models
    exit /b 1
)

:: Check if model contains tdrz
echo %model% | findstr /i "tdrz" >nul
if %errorlevel%==0 (
    set "src=https://huggingface.co/akashmjn/tinydiarize-whisper.cpp"
    set "pfx=resolve/main/ggml"
)

:: Download ggml model
echo Downloading ggml model %model% from '%src%' ...

cd /d "%download_dir%" || exit /b 1

if exist "%download_dir%\ggml-%model%.bin" (
    echo Model %model% already exists. Skipping download.
    exit /b 0
)

:: Try to download with PowerShell
powershell -Command "try { Invoke-WebRequest -Uri '%src%/%pfx%-%model%.bin' -OutFile 'ggml-%model%.bin' -UseBasicParsing; exit 0 } catch { exit 1 }"
if %errorlevel%==0 (
    goto :download_success
)

:: Try with curl if available
curl -L --fail --retry 5 --retry-delay 5 --retry-all-errors --retry-connrefused -o "ggml-%model%.bin" "%src%/%pfx%-%model%.bin"
if %errorlevel%==0 (
    goto :download_success
)

:: Try with bitsadmin as last resort
bitsadmin /transfer whisper_model /download /priority normal "%src%/%pfx%-%model%.bin" "ggml-%model%.bin" >nul 2>&1
if %errorlevel%==0 (
    goto :download_success
)

echo Failed to download ggml model %model%
echo Please try again later or download the original Whisper model files and convert them yourself.
exit /b 1

:download_success
echo.
echo Done! Model '%model%' saved in '%download_dir%\ggml-%model%.bin'
echo You can now use it like this:
echo.
echo   ffmpeg -f whisper -model_file %download_dir%\ggml-%model%.bin -input_file samples/jfk.wav
echo.
exit /b 0

:list_models
echo.
echo Available models:
echo  tiny: tiny, tiny.en, tiny-q5_1, tiny.en-q5_1, tiny-q8_0
echo  base: base, base.en, base-q5_1, base.en-q5_1, base-q8_0
echo  small: small, small.en, small.en-tdrz, small-q5_1, small.en-q5_1, small-q8_0
echo  medium: medium, medium.en, medium-q5_0, medium.en-q5_0, medium-q8_0
echo  large-v1: large-v1
echo  large-v2: large-v2, large-v2-q5_0, large-v2-q8_0
echo  large-v3: large-v3, large-v3-q5_0, large-v3-turbo, large-v3-turbo-q5_0, large-v3-turbo-q8_0
echo.
goto :eof

endlocal
