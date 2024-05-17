# Cookbook

Some example usage

## Use LINK to import
```text
]LINK.Create pnm /Users/ldbeth/Public/Projects/pnmaster/APL_code
```

## Image formats

### Prepare an image NetPBM format

#### PNG
```shell
pngtopnm input.png > out.ppm
```

The program automatically decides whether it outputs PPM or PGM, in case
the PNG image only uses gray scale. The NetPBM programs always write output
to standard ourput.

Use `pgmtoppm` to promote an PGM image to PPM, or in the APL,

```apl
(⊢⍴⍨3,⍴)image
```

### `readpnm`

```apl
    input←pnm.readpnm 'input.pgm'
```


### `writepnm`

```apl
    ⌈/,bit
1
    bit pnm.writepnm 'P4' 'output.pbm' ⍝ PBM file.
    ⌈/,grey
255
    grey pnm.writepnm 'P5' 'output.pgm' ⍝ PGM file.
    ≢color
3
    ⌈/,color
255
    color pnm.writepnm 'P6' 'output.ppm' ⍝ PPM file.
```

## Blue noise pattern and dither

Generate a blue noise pattern of specified radius for dithering:

```apl
      ⍴pnm.Image.Bluenoise.mkda 13
26 26
      ⍴pnm.Image.Bluenoise.MASK64 ⍝ Precomputed pattern
64 64
```

Convert the PGM to PBM using dithering:

```apl
pbm←pnm.Image.(Bluenoise.MASK64⍤Dither.dither) pgm
```

## Curvature filter
```apl
out←pnm.(Pgm.quantize∘Image.curva) in
```

## Knuth's dot diffusion
```apl
out←pnm.Image.(Bluenoise.MASK32∘Dither.diffuse) in
```

## CIELAB Steganography
```apl
lab←pnm.Ppm.cielab pnm.readpnm 'b.ppm'
bin←pnm.readpnm 'o.pbm' ⍝ binary image to hide
pnm.Image.Stega.histo lab ⍝ Find the direction that occurs less
t←pnm.Image.Stega.direc 95
out←lab (t pnm.Image.Stega.gdb 3) bin
ppm←pnm.Ppm.delab out
ppm pnm.writepnm 'P6' 'o.ppm'
decode←pnm.Ppm.cielab pnm.readpnm 'o.ppm'
r←95 pnm.Image.Stega.decode decode
r pnm.writepnm 'P4' 'dec95.pbm'
```