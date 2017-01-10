@echo off
title YouTube auto-generated music downloader with tagging and cover art

set musicdir=Music\
set bin=bin\
set format=m4a128k
set skipdownloadcover=no

if %skipdownloadcover%==no set coverid=,248
if %format%==opus50k set id=249&set extension=opus&goto download
if %format%==opus70k set id=250&set extension=opus&goto download
if %format%==opus160k set id=251&set extension=opus&goto download
if %format%==m4a128k set id=140&set extension=m4a&goto download
if %format%==vorbis128k set id=171&set extension=ogg&goto download
rem There's no more 192k aac on YouTube?

echo Please edit this file and choose a correct format: opus50k, opus70k, opus160k, m4a128k, m4a192k or vorbis128k
pause
exit /b

:download
set /p url=Enter URL:

echo Checking link...
%bin%youtube-dl -s %url% -q >NUL
if %errorlevel%==1 echo There was a problem retrieving the video. Check that the link is correct.&pause&exit /b
if not exist "%musicdir%" mkdir %musicdir%

echo Getting title and artist...
for /f "delims=" %%a in ('%bin%youtube-dl --get-filename -o "%%(title)s" "%url%"') do @set songtitle=%%a
for /f "delims=" %%a in ('%bin%youtube-dl --get-filename -o "%%(uploader)s" "%url%"') do @set uploader=%%a
set uploader=%uploader: - Topic=%
set filename=%uploader% - %songtitle%
echo %filename%
if "%uploader%"==Various Artists goto set /p uploader=Please enter the main artist's name (Because unfortunately the uploader is called 'Various Artists'):
if %skipdownloadcover%==no echo Downloading song and cover...&goto withcover
echo Downloading song...
:withcover
%bin%youtube-dl.exe -f %id%%coverid% -o "%musicdir%%filename%.%%(ext)s" %url% -x -q 2>NUL
if %skipdownloadcover%==yes goto skipcover

echo Extracting album art...
%bin%ffmpeg -loglevel panic -i "%musicdir%%filename%.webm" -ss 00:00:06 -vf crop=732:732:110:108 -q:v 0 -vframes 1 "%musicdir%art.jpg" 2>NUL
%bin%tageditor set title="%songtitle%" artist="%uploader%" cover="%musicdir%art.jpg" --files "%musicdir%%filename%.%extension%"
del "%musicdir%%filename%.webm"
del "%musicdir%%filename%.*.bak
del "%musicdir%art.jpg"


echo Finished!
pause
exit /b

:skipcover
@%bin%tageditor set title="%songtitle%" artist="%uploader%" "%musicdir%%filename%.%extension%" 1>NUL
del "%musicdir%%filename%.*.bak

echo Finished!
pause
exit /b
