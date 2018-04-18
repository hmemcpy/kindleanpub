#!/bin/sh

# https://github.com/hmemcpy/kindleanpub
# Licensed under the 3-clause BSD license, see LICENSE
#
# Copyright (c) 2018, Igal Tabachnik
# All rights reserved.

# Fixes garbled image rendering from LeanPub PDFs on older Kindle devices (e.g. Kindle DX),
# by recompressing the images using JPEG with highest quality.
# The resulting PDF will be smaller, and will render correctly on Kindle devices.

# Original code by Alfred Klomp, http://www.alfredklomp.com/programming/shrinkpdf/

fix ()
{
	echo "Converting $IFILE > $OFILE"

	# Converting using high quality, color preserving, 300 dpi imgs
	# see https://stackoverflow.com/questions/40849325/ghostscript-pdfwrite-specify-jpeg-quality

	gs									\
		-sOutputFile="$2"				\
		-q -dNOPAUSE -dBATCH -dSAFER	\
		-sDEVICE=pdfwrite				\
		-dPDFSETTINGS=/prepress			\
		-c ".setpdfwrite << /ColorACSImageDict << /VSamples [ 1 1 1 1 ] /HSamples [ 1 1 1 1 ] /QFactor 0.08 /Blend 1 >> /ColorImageDownsampleType /Bicubic /ColorConversionStrategy /LeaveColorUnchanged >> setdistillerparams"	\
		-f "$1"
}

usage ()
{
	echo "Reduces PDF filesize by lossy recompressing images to JPEG with Ghostscript."
	echo "Fixes rendering issues with Leanpub PDFs on older Kindle devices."
	echo "  Usage: $1 infile [outfile]"
}

IFILE="$1"

# Need an input file:
if [ -z "$IFILE" ]; then
	usage "$0"
	exit 1
fi

# Output filename defaults to "inputfile-fixed.pdf" unless given:
if [ ! -z "$2" ]; then
	OFILE="$2"
else
	OFILE="${IFILE%.pdf}-fixed.pdf"
fi

fix "$IFILE" "$OFILE" || exit $?