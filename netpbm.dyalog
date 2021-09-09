:Namespace Netpbm

    ∇img←readpnm file;data;x;y;type;⎕IO
     ⎕IO←1
     data←83 ¯1 ⎕MAP file
     type←(3 2⍴'P4P5P6')∧.=⎕UCS 2↑data
     →(~∨/type)⍴err
     data←3↓data
     x y←⌽⍎⎕UCS ¯1↓(⍳∘10↑⊢)data
     →type/pbm pgm ppm
    pbm:
     data←,⍉(8⍴2)⊤256|(⍳∘10↓⊢)data
     img←y(↑⍤1)(x,8×⌈8÷⍨y)⍴data
     →0
    pgm:
     img←x y⍴256|(⍳∘10↓⊢)⍣2⊢data
     →0
    ppm:
     img←(1⌽⍳3)⍉x y 3⍴256|(⍳∘10↓⊢)⍣2⊢data
     →0
     err:'Unknown file magic'
    ∇

    ∇img writepnm(spec file);hdr;dta;x;y;tie
     →((3 2⍴'P4P5P6')∧.=spec)/pbm pgm ppm
     'Unknown file kind'
     →0
    pbm:
     hdr←10,⍨⎕UCS(⍕x y←⌽⍴img)
     dta←,⍉(8×⌈8÷⍨x)↑⍉img
     dta←2⊥⍉((8÷⍨≢dta),8)⍴dta
     →fin
    pgm:
     hdr←10 50 53 53 10,⍨⎕UCS(⍕⌽⍴img)
     dta←,img
     →fin
    ppm:
     hdr←10 50 53 53 10,⍨⎕UCS(⍕x y←⌽1↓⍴img)
     dta←,y(3×x)⍴(¯1⌽⍳3)⍉img
    fin:
     tie←file(⎕NCREATE⍠'IfExists' 'Error')0
     :Trap 0
         tie ⎕ARBOUT(⎕UCS spec),10,hdr,dta
     :Else
         'Error occured when write file'
     :EndTrap
     ⎕NUNTIE tie
    ∇

    :Namespace Ppm
        blkandwt←{⌊0.299 0.587 0.114+.×⍵}
        luminace←{⌊0.3086 0.6094 0.082+.×⍵}
        gamma←{⌊0.5+255×⍺*⍨⍵÷255}
    :EndNamespace

    :Namespace Pgm
        sobel←{
            m←(↑⍉,⍥⊂⊢)1 2 1∘.×1 0 ¯1
            255⌊⌊0.5*⍨(+/*∘2){+/⍪m×⍤2⊢⍵}⌺3 3⊢⍵
        }
        histo←{+⌿(,⍵)∘.=⎕IO-⍨⍳256}
        contrast←{
            L M←⍺
            255⌊(255×⍵>M)⌈(⍵≥L)×1+⌊(⍵-L)×253÷M-L
        }
        equalize←{
            ⎕IO←0
            (⌊255×+\(histo÷≢∘,)⍵)[⍵]
        }
    :EndNamespace

    :Namespace Pbm
        xH←{
            ⎕IO←0
            rot←{
                x y←⌈(⍴⍵)÷2
                frame←(⊢,(3⍴0)∘,⍤1)0 1 3 2[⍉⍵]
                line←⍉(1∘↓⍤1,⊢)y(↑⍤1)⍪(⌽,1,⊢)x/2 0
                line+frame
            }
            ' o-|'[rot⍣⍵⊢1 1⍴1]
        }
    :EndNamespace

:EndNamespace