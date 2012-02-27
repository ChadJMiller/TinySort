@echo off

SET project=tinysort
SET title=TinySort
SET version=1.3.

SET exeYui=java -jar C:\wamp\www\libs\yuicompressor-2.4.1.jar -o
SET exe7z="C:\Program Files\7-Zip\7z.exe"
SET exe7zG=%exe7z% a -tgzip
SET exe7zZ=%exe7z% a -tzip
SET exeRev="C:\Program Files\TortoiseSVN\bin\SubWCRev.exe"
SET exeUUSed="C:\Program Files\UnixUtils\sed.exe"

REM SET exeSed="C:\Program Files\GnuWin32\bin\sed.exe"
REM SET exeSSd="C:\Program Files\superSed\ssed.exe"
REM SET exeUwinSed="C:\Program Files\uWin\usr\bin\sed.exe"

SET base=C:\wamp\www\libs\js\%project%\
SET web=%base%web\
SET scripts=%base%\web\scripts\

SET fileSrc=%scripts%jquery.%project%.js
SET fileMin=%scripts%jquery.%project%.min.js
SET fileGzp=%scripts%jquery.%project%.min.jgz

echo ----- %base% -----

echo ----- FIND REVISION -----
for /f "tokens=5" %%i in ('CALL %exeRev% %base%^|find "Last committed at revision"') do set revision=%%i

echo ----- ADD VERSION TO MAIN SCRIPT -----
CALL %exeUUSed% -i "s/%title%[[:space:]][0-9]\+\.[0-9]\+\.[0-9]\+/%title% %version%%revision%/g" %fileSrc%
CALL %exeUUSed% -i "s/'[0-9]\+\.[0-9]\+\.[0-9]\+/'%version%%revision%/g" %fileSrc%

echo ----- MINIFY -----
CALL %exeYui% %fileMin% %fileSrc%

REM echo ----- SET REVISION -----
REM CALL %exeRev% %base% %fileMin% %fileMin%

echo ----- GZIP -----
CALL %exe7zG% %fileGzp% %fileMin%

echo ----- START COMPRESSION -----
SET fileZip=%base%\web\download\jquery.%project%.%version%%revision%.zip
DEL %fileZip%
CALL %exe7zZ% %fileZip% %web%* -x!download -x!data -x!style\vonRalstar -x!style\screen.css -xr!?svn -xr!?*.php

echo ----- END -----