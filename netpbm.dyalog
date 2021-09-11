:Namespace Netpbm

    ∇ img←readpnm file;data;x;y;type;⎕IO
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

    ∇ img writepnm(spec file);hdr;dta;x;y;tie
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
            h←(3⍴2)⊤0 3 5
            {0<+/,h×⍵}⌺3 3⊢⍵
        }
        erosion←{
            h←(3⍴2)⊤5 6 0
            {4=+/,h×⍵}⌺3 3⊢⍵
        }
        opening←{
            h2←⌽⊖h1←(3⍴2)⊤5 6 0
            {0<+/,h2×⍵}⌺3 3⊢{4=+/,h1×⍵}⌺3 3⊢⍵
        }
        closing←{
            h2←⌽⊖h1←(3⍴2)⊤0 3 5
            {4=+/,h1×⍵}⌺3 3⊢{0<+/,h2×⍵}⌺3 3⊢⍵
        }
        hitndmis←{
            ⍝ find corner
            h2←⌽⊖h1←2=∘.∧⍨2 1 0
            ({3=+/,h1×⍵}⌺3 3∧{3=+/,h2×⍵}⌺3 3∘~)⍵
        }
        mofilter←{
            h←∘.∨⍨0 1 0
            ({0<+/,h×⍵}⌺3 3)⍣2{4=+/,h×⍵}⌺3 3⊢⍵
        }

        ∇ r←thinning img;shft;cp1;cp2;cp3;ms;bs
          ;c1;c2;c3;pass;⎕IO
          ⎕IO←1
          shft←↓↑⍨⍴⍤⊢××⍤⊣+0=⊣
          cp1←{(~ms[1⌷⍵;;])∧ms[2⌷⍵;;]∨ms[3⌷⍵;;]}
          cp2←{⊃+⌿∨/4 2⍴⊂⍤2⊢ms[⍵;;]}
          cp3←{(ms[1⌷⍵;;]∨ms[2⌷⍵;;]∨~ms[3⌷⍵;;])∧ms[4⌷⍵;;]}
         ⍝ up down left right uplft uprht dnlft dnrht
         ⍝ 1   2    3    4     5     6     7     8
         loop1:
          r←img
          pass←0
         loop2:
          ms←↑(¯1 0)(1 0)(0 ¯1)(0 1)(¯1 ¯1)(¯1 1)(1 ¯1)(1 1)shft¨⊂img
          c1←⊃+/cp1¨(4 6 1)(1 5 3)(3 7 2)(2 8 4)
          c2←⊃⌊/cp2¨(4 6 1 5 3 7 2 8)(1 6 3 5 2 7 4 8)
          c3←cp3⊃(0 1=pass)/(6 1 8 4)(7 2 5 3)
          img←img×~c3∧(c2≥2)∧(c2≤3)∧(c1=1)
          →pass/endtest
          pass←1
          →loop2
         endtest:
          →(r≡img)/0
          →loop1
        ∇

        remnoise←{
            h←(3⍴2)⊤7 5 7
            (⊢∧{0<+/,h×⍵}⌺3 3)⍵
        }

        fill←{
            h←(3⍴2)⊤7 5 7
            (⊢∨{8=+/,h×⍵}⌺3 3)⍵
        }

        bound←{(⊢∧9≠{+/,⍵}⌺3 3)⍵}
    :EndNamespace

:EndNamespace
