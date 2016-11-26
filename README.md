# youtube-auto-generated-music-downloader
Script to automatically download YouTube auto-generated music with tagging and album cover.

Uses youtube-dl, ffmpeg and tageditor.

One of my first projects that actually does something (not just a hello world one.)

## Instructions
Run the batch file and paste the YouTube auto-generated music link there (ctrl+v if on Windows 10 or right click with your mouse).

You can also edit the batch file to change some parameters:
* musicdir: The folder where the music will be stored.
* format: opus50k, opus70k, opus160k, m4a128k, m4a192k or vorbis128k
* bin: The location of the binary folder.
* skipdownloadercover: whether to skip downloading cover or not.


#### TODO

* Properly format this readme...
* Add more possible metadata (album, other artists, year)
* Add Opus, Vorbis, MP3...
* Write the documentation.
* Finish the code.
* maybe write a Bash version?
* and lots more...
* Change the way the artist's name is retrieved
* Some scenarios to fix.... 


1. Names in foreign languages...
*  https://www.youtube.com/watch?v=Nh_bdvA8cVM
* https://www.youtube.com/watch?v=-mLpe7KUg9U

2. Lots of artists...
* https://www.youtube.com/watch?v=l-uVkrzo8eU
* https://www.youtube.com/watch?v=6I2y_UbVz4U

3. Various artists...
* https://www.youtube.com/watch?v=AKXlKL7CAZk
