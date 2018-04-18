### What is this?
A small shell script that fixes garbled/broken image rendering on (older) Kindle devices of PDFs purchased on [Leanpub](https://leanpub.com/).

Using [Ghostscript](https://www.ghostscript.com/), this script will convert all images inside the PDF to JPEG using highest quality conversion.  
This will result in smaller output PDF size, and will make the images render properly on older Kindles (e.g. Kindle DX)

### Usage

    $ pdfix.sh input.pdf

Will produce a file `input-fixed.pdf` in the same directory.

Ghostscript installation is required! Install on macOS using [Homebrew](https://brew.sh/):
    
    brew install ghostscript
    
Or on Ubuntu / Bash on Windows (WSL) using:

    sudo apt-get install ghostscript

(not tested on Windows, but should work!)

#### Example
> (from [An Outsider's Guide to Statically Typed Functional Programming](https://leanpub.com/outsidefp))

Before (11.1MB) |  After (7.23MB)
:--------------:|:---------------:
![before](https://user-images.githubusercontent.com/601206/38953873-bd45cbf6-4358-11e8-8fcb-1fee5d25784a.png) | ![after](https://user-images.githubusercontent.com/601206/38953868-bb9775a2-4358-11e8-9047-51f6b43b3f50.png)
