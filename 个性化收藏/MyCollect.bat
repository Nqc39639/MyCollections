@echo off
echo [31m����Ȩ���ƣ�����NQC(QQ 2078715462)ͬ���ʹ�ã�������[0m
echo     [31m(ע����������޸�ϵͳ�ļ��������ʹ�ã�����)[0m

:menu
echo ===================================================
echo ��ѡ��Ҫִ�еĲ�����
echo --------0. �˳�����--------
echo --------1. ȫ��ִ��--------
echo --------2. ��������Դ��������--------
echo --------3. ���Ҽ��˵���--------
echo --------4. ����������ʾ���--------
echo --------5. �ﱾ������ԡ�--------
echo --------6. ��Office������ʾ��--------
echo --------7. �������еġ���ҳ����--------
echo --------8. ���޸�ϵͳ�����--------
choice /C 012345678 /M "������ѡ���������:" /N
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
echo �ѳɹ�ִ�У�����
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
choice /C YNC /M "����/�ر�/ȡ��[Y/N/C]:" /N
if %errorlevel%==1 (
    C:
    cd C:\Windows
    echo taskkill /f /im explorer.exe ^& start explorer.exe > restart.bat
    reg add "HKCR\Directory\Background\shell\restart" /f /ve /d "������Դ������" > nul
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
choice /C 01C /M "Win11��Win10/Win10��Win11/ȡ��[0/1/C]:" /N
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
choice /C YNC /M "����/�ر�/ȡ��[Y/N/C]:" /N
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
choice /C YNC /M "����/�ر�/ȡ��[Y/N/C]:" /N
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
choice /C YNC /M "����/�ر�/ȡ��[Y/N/C]:" /N
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
REM Ĭ��ֵ����Ϊ msyh.ttc, msyhbd.ttc, msyhl.ttc
goto success
