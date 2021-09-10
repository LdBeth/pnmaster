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
        enhence←{0⌈255⌊⌊(1-⍺)÷⍨⍵-⍺×⍵÷⍥({+/,⍵}⌺3 3)1⍴⍨⍴⍵}
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
        dilation←{
            h←3 3⍴(9⍴2)⊤83
            {0<+/,h×⍵}⌺3 3⊢⍵
        }
        erosion←{
            h←3 3⍴(9⍴2)⊤404
            {3<+/,h×⍵}⌺3 3⊢⍵
        }
        opening←{
            h2←⌽⊖h1←3 3⍴(9⍴2)⊤404
            {0<+/,h2×⍵}⌺3 3⊢{3<+/,h1×⍵}⌺3 3⊢⍵
        }
        closing←{
            h2←⌽⊖h1←3 3⍴(9⍴2)⊤83
            {3<+/,h1×⍵}⌺3 3⊢{0<+/,h2×⍵}⌺3 3⊢⍵
        }
        hitndmis←{
            ⍝ find corner
            h2←⌽⊖h1←2=∘.∧⍨2 1 0
            ({2<+/,h1×⍵}⌺3 3∧{2<+/,h2×⍵}⌺3 3∘~)⍵
        }
        mofilter←{
            h←∘.∨⍨0 1 0
            ({0<+/,h×⍵}⌺3 3)⍣2{3<+/,h×⍵}⌺3 3⊢⍵
        }

        ∇r←thinning img;shft;up;down;left;right
         ;uplft;uprht;dnlft;dnrht;b1;b2;b3;b4
         ;c1;s1;s2;c2;c3;pass
         shft←↓↑⍨⍴⍤⊢×∘×⊣+¯1<×⍤⊣
        loop1:
         r←img
         pass←0
        loop2:
         up←¯1 0 shft img
         down←1 0 shft img
         left←0 ¯1 shft img
         right←0 1 shft img
         uplft←¯1 ¯1 shft img
         uprht←¯1 1 shft img
         dnlft←1 ¯1 shft img
         dnrht←1 1 shft img
         b1←right∧uprht∨up
         b2←up∧uplft∨left
         b3←left∧dnlft∨down
         b4←down∧dnrht∨right
         c1←b1+b2+b3+b4
         s1←(right∨uprht)+(up∨uplft)+(left∨dnlft)+(down∨dnrht)
         s2←(up∨uprht)+(left∨uplft)+(down∨dnlft)+(right∨dnrht)
         c2←s1⌊s2
         →pass/p2
         c3←(uprht∨up∨~dnrht)∧right
         img←img×~c3∧(c2≥2)∧(c2≤3)∧(c1=1)
         pass←1
         →loop2
        p2:
         c3←(dnlft∨down∨~uplft)∧left
         img←img×~c3∧(c2≥2)∧(c2≤3)∧(c1=1)
         →(r≡img)/0
         →loop1
        ∇
     :EndNamespace

:EndNamespace