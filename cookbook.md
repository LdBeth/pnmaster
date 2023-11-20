# Cookbook

Some example usage

## Use LINK to import
```text
]LINK.Create pnm /Users/ldbeth/Public/Projects/pnmaster/APL_code
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
bin←pnm.readpnm 'o.pbm'
pnm.Image.Stega.histo lab ⍝ Find the direction that occurs less
t←pnm.Image.Stega.direc 95
out←lab (t pnm.Image.Stega.gdb 3) bin
ppm←pnm.Ppm.delab out
ppm pnm.writepnm 'P6' 'o.ppm'
decode←pnm.Ppm.cielab pnm.readpnm 'o.ppm'
r←95 pnm.Image.Stega.decode decode
r pnm.writepnm 'P4' 'dec95.pbm'
```