rem @echo off
title YouTube auto-generated music downloader with tagging and cover art

set processed=Processed\
set unprocessed=Unprocessed\
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
youtube-dl -s %url%
if %errorlevel%==1 echo There was a problem retrieving the video. Check that the link is correct.&pause&exit /b

echo Getting name and artist...
for /f "delims=" %%a in ('youtube-dl --get-filename -o "%%(title)s" "%url%"') do @set songtitle=%%a
for /f "delims=" %%a in ('youtube-dl --get-filename -o "%%(uploader)s" "%url%"') do @set uploader=%%a
set uploader=%uploader: - Topic=%
echo %uploader% - %songtitle%
rem if author = various artists...
if %skipdownloadcover%==no echo Downloading song and cover...&goto withcover
echo Downloading song...
:withcover
youtube-dl.exe -f %id%%coverid% -o "%unprocessed%%uploader% - %songtitle%.%%(ext)s" %url% -x
if %skipdownloadcover%==yes goto skipcover
ffmpeg -i "%unprocessed%%uploader% - %songtitle%.webm" -ss 00:00:06 -vf crop=734:734:109:108 -q:v 0 -vframes 1 "%unprocessed%art.jpg"
rem ffmpeg -i "%unprocessed%%uploader% - %songtitle%.%extension%" --artwork "%unprocessed%art.jpg" -codec copy -id3v2_version 3 -metadata title="%songtitle%" -metadata artist="%uploader%" "%processed%%uploader% - %songtitle%.%extension%"
ffmpeg -i "%unprocessed%%uploader% - %songtitle%.%extension%" -metadata title="%songtitle%" -metadata artist="%uploader%" -codec copy "%processed%%uploader% - %songtitle%.%extension%"
AtomicParsley "%unprocessed%%uploader% - %songtitle%.%extension%" --artwork art.jpg 
del "%unprocessed%%uploader% - %songtitle%.*"
del "%unprocessed%art.jpg"


echo Finished!
pause
exit /b

:skipcover
ffmpeg -i "%unprocessed%%uploader% - %songtitle%.%extension%" -metadata title="%songtitle%" -metadata artist="%uploader%" -codec copy "%processed%%uploader% - %songtitle%.%extension%"
del "%unprocessed%%uploader% - %songtitle%.*"

echo Finished!
pause
exit /b



pause
