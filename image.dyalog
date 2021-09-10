:Namespace Image

    tiling←⊣⍴⊢/⍤⊣⍴⍤1⊢
    enhence←{0⌈255⌊⌊(1-⍺)÷⍨⍵-⍺×⍵(÷⍥({+/,⍵}⌺3 3))1⍴⍨⍴⍵}
    quant←{⊃∘⍋⍤1⊢|⍵∘.-⍺}
    linear←{(1÷⍵-1)×⎕IO-⍨⍳⍵}

    :Namespace Bluenoise
        ∇da←mkda r
         ;m;w;g;s;gauss;cluster;void;imax
         ;l;v;bp;pt;rank;loc;all;⎕IO
         ⎕IO←0
         m←,⍨2×r
         gauss←{*-4.5÷⍨∘.+⍨2*⍨(⌽,1∘↓)⍳1+⍵}
         ⍝ use interger approximation
         s←⍴g←s⌿(s←0≠+/g)/g←⌊0.5+(⊢××/∘⍴)gauss r
         cluster←⊢×(-,⍨r)↓(,⍨r)↓{+/,g×⍵}⌺s∘(r⊖⍪⍨)∘(r⌽,⍨)
         void←cluster∘~
         imax←,⍳(⌈/⌈/)
         bp←?m⍴2
        loop:
         l←imax cluster bp
         (l⌷,bp)←0
         v←imax void bp
         (v⌷,bp)←1
         →(l≠v)/loop
         pt←bp
         da←m⍴0
         rank←¯1++/,bp
         :While rank≥0
             loc←imax cluster pt
             (loc⌷,pt)←0
             (loc⌷,da)←rank
             rank-←1
         :EndWhile
         pt←bp
         rank←+/,bp
         all←×/m
         :While rank<all
             loc←imax void pt
             (loc⌷,pt)←1
             (loc⌷,da)←rank
             rank+←1
         :EndWhile
        ∇
    :EndNamespace

    :Namespace Dither
        diffuse←{
            ⎕DIV←1
            in←(1-⍵÷255)
            g←3 3⍴1 2 1 2 3 2 1 2 1
            m←⍺ ##.tiling⍨⍴⍵
            aux←{
                k←m=⍺
                b←0.5≤a←in×k
                err←a-b
                w←{+/,g×⍵}⌺3 3⊢m>⍺
                c←err÷w
                in+←({+/,g×⍵}⌺3 3)c
                b∨⍵}
            ⊃aux/(⌽⍳≢,⍺),0
        }
        dither←{
            (1-⍵÷255)≥(⍴⍵)##.tiling(0.5∘+÷≢∘,)⍺
        }
        colordither←{
            q←{⌊r×⌊(r←255÷⍺-1)÷⍨⍵}
            s←⍵+(255÷(0.5+≢,⍺)×⍺⍺-1)×⍤0 2⊢(⍴⍵)##.tiling ⍺
            255⌊⍺⍺(q⍤0 2)s
        }
    :EndNamespace

    :Namespace Blur
        boxblur←{⌊({+/,⍵}⌺b⊢⍵)÷{+/,⍵}⌺(b←1+2×,⍨⍺)⊢(⍴⍵)⍴1}
        gblur←{
            ⎕IO←0
            l rad←⍺
            m←(⍴⍵)⍴1
            box←{({+/,⍵}⌺s⊢⍵)÷{+/,⍵}⌺(s←⍺ ⍺)⊢m}
            bforg←{
                wl←(⊢-(~2∘|))⌊0.5*⍨1+⍺÷⍨i←12×⍵*2
                m←(⌊0.5+⊢)(¯4×1+wl)÷⍨i-+/(wl*2 1 0)×1 4 3×⍺
                wl+2×m≤⍳⍺
            }
            ⌊⊃box/(l bforg rad),⊂⍵
        }
    :EndNamespace

    :Namespace Interpol
        nearest←{
            img←⍺
            x y←⍵
            a b←(⍴img)(##.quant⍥##.linear)¨⍵
            img[a;b]
        }
    :EndNamespace
:EndNamespace