#!/bin/sh

# https://github.com/hmemcpy/kindleanpub
# Licensed under the 3-clause BSD license, see LICENSE
#
# Copyright (c) 2018, Alfred Klomp, Igal Tabachnik
# All rights reserved.

# Fixes garbled image rendering from LeanPub PDFs on older Kindle devices (e.g. Kindle DX),
# by recompressing the images using JPEG with highest quality.
# The resulting PDF will be smaller, and will render correctly on Kindle devices.

# Original code from http://www.alfredklomp.com/programming/shrinkpdf/
# Modified with command taken from https://stackoverflow.com/questions/40849325/ghostscript-pdfwrite-specify-jpeg-quality

shrink ()
{
	echo "Converting $IFILE > $OFILE"

	gs									\
		-sOutputFile="$2"				\
		-q -dNOPAUSE -dBATCH -dSAFER	\
		-sDEVICE=pdfwrite				\
		-dPDFSETTINGS=/prepress			\
		-c ".setpdfwrite << /ColorACSImageDict << /VSamples [ 1 1 1 1 ] /HSamples [ 1 1 1 1 ] /QFactor 0.08 /Blend 1 >> /ColorImageDownsampleType /Bicubic /ColorConversionStrategy /LeaveColorUnchanged >> setdistillerparams"	\
		-f "$1"
}

check_smaller ()
{
	# If $1 and $2 are regular files, we can compare file sizes to
	# see if we succeeded in shrinking. If not, we copy $1 over $2:
	if [ ! -f "$1" -o ! -f "$2" ]; then
		return 0;
	fi
	ISIZE="$(echo $(wc -c "$1") | cut -f1 -d\ )"
	OSIZE="$(echo $(wc -c "$2") | cut -f1 -d\ )"
	if [ "$ISIZE" -lt "$OSIZE" ]; then
		echo "Input smaller than output, doing straight copy" >&2
		cp "$1" "$2"
	fi
}

usage ()
{
	echo "Reduces PDF filesize by lossy recompressing with Ghostscript."
	echo "Not guaranteed to succeed, but usually works."
	echo "  Usage: $1 infile"
}

IFILE="$1"

# Need an input file:
if [ -z "$IFILE" ]; then
	usage "$0"
	exit 1
fi

# Output filename defaults to "-" (stdout) unless given:
if [ ! -z "$2" ]; then
	OFILE="$2"
else
	OFILE="${IFILE%.pdf}-fixed.pdf"
fi

shrink "$IFILE" "$OFILE" || exit $?

check_smaller "$IFILE" "$OFILE"
