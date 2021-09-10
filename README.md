# PNMaster

## LICENSE

BSD 2-Clause “Simplified” License

## Netpbm

Beware that this library can only read and write raster PNM files
produced by Netpbm command line programs. Other PNM files might fail.

### `readpnm`

Example:

```
    input←readpnm 'input.pgm'
```


### `writepnm`

Example:

```
    ⌈/,bit
1
    bit writepnm 'P4' 'output.pbm' ⍝ PBM file.
    ⌈/,grey
255
    grey writepnm 'P5' 'output.pgm' ⍝ PGM file.
    ≢color
3
    ⌈/,color
255
    color writepnm 'P6' 'output.ppm' ⍝ PPM file.
```

