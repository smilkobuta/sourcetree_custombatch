rm %3\files.txt
rm %3\files.zip

if "%2" EQU "" (
  set PARAM1=HEAD
  set PARAM2=%1
) else (
  set PARAM1=%1
  set PARAM2=%2
)

setlocal enabledelayedexpansion

set diff_lines=
for /F "usebackq" %%i in (`git diff --name-only %PARAM1% %PARAM2%`) do (
  echo %%i>> %3\files.txt
)

cat %3\files.txt | zip -@ %3\files.zip
rm %3\files.txt

explorer %3
echo ok
