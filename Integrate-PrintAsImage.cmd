@echo off
setlocal EnableDelayedExpansion
set path=%path%;%~dp0
set l=%temp%\printers.list
if exist "%l%" del "%l%"
for /f "tokens=7 delims=\" %%p in ('^
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Print\Printers"') do (
echo %%p >> "%l%"
)
for /f "tokens=4 delims=\" %%p in ('^
reg query "HKCU\Printers\Connections"') do (
echo %%p | sed "s/,/\\/g" >> "%l%"
)
for /f "tokens=*" %%p in ('^
type "%l%" ^|
sed "s/[ \t]*$//g" ^|
awk "BEGIN { q="""\x22"""}{print """t""" FNR """ /t REG_SZ /d """ q $0 q}"') do (
echo %%p
for %%a in (9 10 11) do (
reg add "HKCU\Software\Adobe\Acrobat Reader\%%a.0\General\cPrintAsImage" /v %%p /f
)
)
if exist "%l%" del "%l%"
endlocal
