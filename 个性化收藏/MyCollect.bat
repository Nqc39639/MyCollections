@echo off
echo [31m¡¾°æÈ¨ÏŞÖÆ£¬ÇëÔÚNQC(QQ 2078715462)Í¬ÒâºóÊ¹ÓÃ£¡£¡£¡¡¿[0m
echo     [31m(×¢£º±¾³ÌĞò»áĞŞ¸ÄÏµÍ³ÎÄ¼ş£¬Çë½÷É÷Ê¹ÓÃ£¡£¡£¡)[0m

:menu
echo ===================================================
echo ÇëÑ¡ÔñÒªÖ´ĞĞµÄ²Ù×÷£º
echo --------0. ÍË³ö³ÌĞò--------
echo --------1. È«²¿Ö´ĞĞ--------
echo --------2. ¡ïÖØÆô×ÊÔ´¹ÜÀíÆ÷¡ï--------
echo --------3. ¡ïÓÒ¼ü²Ëµ¥¡ï--------
echo --------4. ¡ïÈÎÎñÀ¸ÏÔÊ¾Ãë¡ï--------
echo --------5. ¡ï±¾µØ×é²ßÂÔ¡ï--------
echo --------6. ¡ïOfficeµÁ°æÌáÊ¾¡ï--------
echo --------7. ¡ïÉèÖÃÖĞµÄ¡°Ö÷Ò³¡±¡ï--------
echo --------8. ¡ïĞŞ¸ÄÏµÍ³×ÖÌå¡ï--------
choice /C 012345678 /M "ÇëÊäÈëÑ¡ÔñµÄÉèÖÃÏî:" /N
if %errorlevel%==1 exit
if %errorlevel%==2 call :execAll
if %errorlevel%==3 call :execToggleRestart
if %errorlevel%==4 call :execToggleContextMenu
if %errorlevel%==5 call :execToggleShowSeconds
if %errorlevel%==6 call :execLocalPolicy
if %errorlevel%==7 call :execToggleOfficeTips
if %errorlevel%==8 call :execToggleHome
if %errorlevel%==9 call :execFont

:success
echo ÒÑ³É¹¦Ö´ĞĞ£¡£¡£¡
goto menu

:execAll
call :execToggleRestart
call :execToggleContextMenu
call :execToggleShowSeconds
call :execLocalPolicy
REM call :execToggleOfficeTips
call :execToggleHome
REM call :execFont
goto success

:execToggleRestart
choice /C YNC /M "¿ªÆô/¹Ø±Õ/È¡Ïû[Y/N/C]:" /N
if %errorlevel%==1 (
    C:
    cd C:\Windows
    echo taskkill /f /im explorer.exe ^& start explorer.exe > restart.bat
    reg add "HKCR\Directory\Background\shell\restart" /f /ve /d "ÖØÆô×ÊÔ´¹ÜÀíÆ÷" > nul
    reg add "HKCR\Directory\Background\shell\restart\command" /f /ve /d "C:\Windows\restart.bat" > nul
    goto success
)
if %errorlevel%==2 (
    C:
    cd C:\Windows
    del restart.bat
    reg delete "HKCR\Directory\Background\shell\restart" /f > nul
    goto success
)
goto menu

:execToggleContextMenu
choice /C 01C /M "Win11¡úWin10/Win10¡úWin11/È¡Ïû[0/1/C]:" /N
if %errorlevel%==1 (
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve > nul
    goto success
)
if %errorlevel%==2 (
    reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f > nul
    goto success
)
goto menu

:execToggleShowSeconds
choice /C YNC /M "¿ªÆô/¹Ø±Õ/È¡Ïû[Y/N/C]:" /N
if %errorlevel%==1 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f > nul
    goto success
)
if %errorlevel%==2 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 0 /f > nul
    goto success
)
goto menu

:execLocalPolicy
pushd "%~dp0"
dir /b C:\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum > List.txt
dir /b C:\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >> List.txt
for /f %%i in ('findstr /i . List.txt 2^> nul') do dism /online /norestart /add-package:"C:\Windows\servicing\Packages\%%i" > nul
del /f /q List.txt
goto success

:execToggleOfficeTips
choice /C YNC /M "¿ªÆô/¹Ø±Õ/È¡Ïû[Y/N/C]:" /N
if %errorlevel%==1 (
    reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\UpdateUrl" /f > nul
    reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\UpdateToVersion" /f > nul
    reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Updates\UpdateToVersion" /f > nul
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\OfficeUpdate" /f > nul
    reg add "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" /v CDNBaseUrl /t REG_SZ /d "http://officecdn.microsoft.com/pr/F2E724C1-748F-4B47-8FB8-8E0D210E9208" /f > nul
    goto success
)
if %errorlevel%==2 (
    reg add "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" /v CDNBaseUrl /t REG_SZ /d "http://officecdn.microsoft.com/pr/492350F6-3A01-4F97-B9C0-C7C6DDF67D60" /f > nul
    goto success
)
goto menu

:execToggleHome
choice /C YNC /M "¿ªÆô/¹Ø±Õ/È¡Ïû[Y/N/C]:" /N
if %errorlevel%==1 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v SettingsPageVisibility /t REG_SZ /d "hide:home" /f > nul
    goto success
)
if %errorlevel%==2 (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v SettingsPageVisibility /f > nul
    goto success
)
goto menu

:execFont
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Microsoft YaHei & Microsoft YaHei UI (TrueType)" /t REG_SZ /d "simkai.ttf" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Microsoft YaHei Bold & Microsoft YaHei UI Bold (TrueType)" /t REG_SZ /d "simkai.ttf" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Microsoft YaHei Light & Microsoft YaHei UI Light (TrueType)" /t REG_SZ /d "simkai.ttf" /f > nul
REM Ä¬ÈÏÖµÒÀ´ÎÎª msyh.ttc, msyhbd.ttc, msyhl.ttc
goto success
