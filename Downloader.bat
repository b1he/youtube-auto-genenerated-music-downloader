@echo off
title YouTube auto-generated music downloader with tagging and cover art

set processed=Processed\
set unprocessed=Unprocessed\
set format=m4a128k
set skipdownloadcover=no

if %skipdownloadcover%==no set coverid=,248
if %format%==opus50k echo Opus Coming Soon...&pause&exit /b
if %format%==opus70k echo Opus Coming Soon...&pause&exit /b
if %format%==opus160k echo Opus Coming Soon...&pause&exit /b
if %format%==m4a128k set id=140&set extension=m4a&goto download
if %format%==vorbis128k set Vorbis echo Coming Soon...&pause&exit /b
rem There's no more 192k aac on YouTube?

echo Please edit this file and choose a correct format: opus50k, opus70k, opus160k, m4a128k, m4a192k or vorbis128k
pause
exit /b

:download
set /p url=Enter URL:

echo Checking link...
youtube-dl -s %url% -q
if %errorlevel%==1 echo There was a problem retrieving the video. Check that the link is correct.&pause&exit /b

echo Getting title and artist...
for /f "delims=" %%a in ('youtube-dl --get-filename -o "%%(title)s" "%url%"') do @set songtitle=%%a
for /f "delims=" %%a in ('youtube-dl --get-filename -o "%%(uploader)s" "%url%"') do @set uploader=%%a
set uploader=%uploader: - Topic=%
echo %uploader% - %songtitle%
if "%uploader%"==Various Artists goto set /p uploader=Please enter the main artist's name (Because unfortunately the uploader is called 'Various Artists'):
if %skipdownloadcover%==no echo Downloading song and cover...&goto withcover
echo Downloading song...
:withcover
youtube-dl.exe -f %id%%coverid% -o "%processed%%uploader% - %songtitle%.%%(ext)s" %url% -x -q
if %skipdownloadcover%==yes goto skipcover

echo Extracting album art...
ffmpeg -loglevel panic -i "%processed%%uploader% - %songtitle%.webm" -ss 00:00:06 -vf crop=734:734:109:108 -q:v 0 -vframes 1 "%processed%art.jpg"
@tageditor set title="%songtitle%" artist="%uploader%" cover="%processed%art.jpg" --files "%processed%%uploader% - %songtitle%.%extension%" --max-padding 10
del "%processed%%uploader% - %songtitle%.webm"
del "%processed%art.jpg"


echo Finished!
pause
exit /b

:skipcover
@tageditor set title="%songtitle%" artist="%uploader%" cover="%unprocessed%art.jpg" "%processed%%uploader% - %songtitle%.%extension%"
del "%unprocessed%%uploader% - %songtitle%.*"

echo Finished!
pause
exit /b



pause
