@ECHO OFF
SET "PLAYNITE_PATH=%LOCALAPPDATA%\Playnite\Playnite.FullscreenApp.exe"

:: Controller Early Exit Check
powershell -NoProfile -Command ^ "$dev = Get-PnpDevice | Where-Object {$_.FriendlyName -like '*xbox 360 controller*' -and $_.Status -eq 'OK'}; if ($dev) { exit 0 } else { exit 1 }"
IF NOT "%ERRORLEVEL%" == "0" (EXIT /B)

:: Kill Explorer
taskkill /t /f /im explorer.exe

:: Start Boot Video
START "" "%~dp0..\mpv.exe" --script-opts=osc-visibility=never --ontop --no-terminal --fullscreen --loop "%~dp0Videos\BootVideo.mp4"

:: Start Playnite
START "" "%PLAYNITE_PATH%" --hidesplashscreen

:: Wait for Video to start
set "WindowTitle=mpv"
:waitforvideo
timeout /t 1 >nul
tasklist /v | findstr /i "mpv" >nul || goto waitforvideo

:: Restart Explorer
START explorer.exe

:: Wait for Playnite to start
set "WindowTitle=Playnite"
:waitforlauncher
timeout /t 1
@for /f "Delims=:" %%a in ('tasklist /fi "WINDOWTITLE eq %WindowTitle%"') do @if %%a==INFO goto waitforlauncher

:: Wait for 3 secs for Launcher fully loaded before quit/kill Boot Video
:: timeout /t 3
taskkill /f /im mpv.exe

:: Focus on Playnite
START "" wscript.exe "%~dp0FocusPlaynite.vbs"

exit
