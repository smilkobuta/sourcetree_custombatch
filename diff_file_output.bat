rm %3\diffs.txt
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

echo "%PARAM1% %PARAM2%" > %3\files.txt

set diff_lines=
for /F "usebackq" %%i in (`git diff --name-only %PARAM1% %PARAM2%`) do (
  echo %%i>> %3\files.txt
  echo - [%%i]^(files/%%i.diff^)>> %3\diffs.txt
)

echo.>> %3\files.txt
cat %3\diffs.txt>> %3\files.txt
rm %3\diffs.txt

cat %3\files.txt | zip -@ %3\files.zip
mkdir %3\__work
cd %3\__work
unzip %3\files.zip
cd ..\

for /F "usebackq" %%i in (`git diff --name-only %PARAM1% %PARAM2%`) do (
  git diff %PARAM2% %PARAM1% %%i > %3\__work\%%i.diff
)

cd %3\__work
zip -r files.zip *
cd ..\
mv %3\__work\files.zip %3\files.zip
rm -rf %3\__work

explorer %3
echo ok
