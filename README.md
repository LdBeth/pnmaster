# PNMaster

An APL image processing library complements NetPBM.

## LICENSE

[BSD 2-Clause “Simplified” License](LICENSE)

## Workspace Size

The default `MAXWS` is too small for process any larger images, it is
recommended to set it to above `640M` and `2G` is the size suitable
for typical online avaliable digital images. Please consult the
Installation and Configuration Guide to the platform of your Dyalog
APL for how to set this parameter.

## [NetPBM](https://netpbm.sourceforge.net)

Beware that this library can only read and write files in raster PNM
format produced by Netpbm command line programs. PNM files produced by
other programs, for example, Preview.app on OS X, although complaints
to PNM file specification, might failed to be read by this library. It
that case `pnmtopnm` can be used to normalized the image format.

This libarary also makes the assumption that grayscale/colored images
uses 8-bit color.

## Workspace organization

```
Netpbm
 |
 +-Ppm ⍝ Functions categoriezed by input type.
 +-Pgm
 +-Pbm
 |
 +-Image ⍝ Util functions.
    | ⍝ Functions categoriezed by effects.
    |
    +-Bluenoise ⍝ For dithering.
    +-Dither
    +-Noise ⍝ Add noise to images
    |
    +-Blur
    +-HaldCLUT ⍝ Color Look Up Table
    |
    +-Recons ⍝ Reconstruction of images.
```

## Documentation

See [cookbook](cookbook.md).
