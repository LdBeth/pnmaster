#!/usr/local/bin/dyalogscript MAXWS=3GB
⎕LOAD'../pnm'
∇file update expr
 :If ~⎕NEXISTS file
     (imgtype file)pnm.writepnm⍨⍎expr
 :EndIf
∇
ppm←pnm.readpnm'feline.ppm'
pgm←pnm.Ppm.blkandwt ppm
1⎕MKDIR'out'
imgtype←'P4'
'out/line.pbm'update'pnm.Image.Dither.(D.LINE∘dither)pgm'
'out/diff.pbm'update'pnm.Image.Dither.(D.DIAMASK∘diffuse)pgm'
'out/blue.pbm'update'pnm.Image.(Bluenoise.MASK64∘Dither.dither)pgm'
imgtype←'P5'
'out/grey.pgm'update'pgm'
'out/sobe.pgm'update'pnm.Pgm.sobel pgm'
'out/boxd.pgm'update'5 pnm.Image.Blur.boxblur pgm'
imgtype←'P6'
'out/sola.ppm'update'pnm.(Pgm.solarize Ppm.eachrgb)ppm'
'out/medi.ppm'update'pnm.((3∘Pgm.median)Ppm.eachrgb)ppm'
'out/cold.ppm'update'pnm.Image.Dither.(D.SCREEN45M4∘(8 8 8 colordither))ppm'
