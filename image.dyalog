:Namespace Image

    tiling←⊣⍴⊢/⍤⊣⍴⍤1⊢
    enhence←{0⌈255⌊⌊(1-⍺)÷⍨⍵-⍺×⍵(÷⍥({+/,⍵}⌺3 3))1⍴⍨⍴⍵}
    quant←{⊃∘⍋⍤1⊢|⍵∘.-⍺}
    linear←{(1÷⍵-1)×⎕IO-⍨⍳⍵}

    :Namespace Bluenoise
        ∇da←mkda r
         ;m;g;s;gauss;cluster;void;imax
         ;l;v;bp;pt;rank;loc;all;⎕IO
         ⎕IO←0
         m←,⍨2×r ⋄ bp←?m⍴2
         gauss←{*-4.5÷⍨∘.+⍨2*⍨(⌽,1∘↓)⍳1+⍵}
         ⍝ use interger approximation
         s←⍴g←s⌿(s←0≠+/g)/g←⌊0.5+(⊢××/∘⍴)gauss r
         cluster←⊢×(-,⍨r)↓(,⍨r)↓{+/,g×⍵}⌺s∘(r⊖⍪⍨)∘(r⌽,⍨)
         void←cluster~ ⋄ imax←,⍳(⌈/⌈/)
         loop:
         l←imax cluster bp
         (l⌷,bp)←0
         v←imax void bp
         (v⌷,bp)←1
         →(l≠v)/loop
         pt←bp ⋄ da←m⍴0 ⋄ rank←¯1++/,bp
         :While rank≥0
             loc←imax cluster pt
             (loc⌷,pt)←0
             (loc⌷,da)←rank
             rank-←1
         :EndWhile
         pt←bp ⋄ rank←+/,bp ⋄ all←×/m
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
            ⎕DIV←⎕IO←1
            in←1-⍵÷255
            g←3 3⍴1 2 1 2 3 2 1 2 1
            m←⍺ ##.tiling⍨⍴⍵
            cvol←{+/,g×⍵}⌺3 3
            ⊃{
                b←0.5≤a←in×m=⍺
                err←a-b
                c←err÷cvol m>⍺
                in+←cvol c
                b∨⍵}/(⌽⍳≢,⍺),0
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
        boxblur←{⌊⍵÷⍥({+/,⍵}⌺(1+2×⍺ ⍺))1⍴⍨⍴⍵}
        gblur←{
            ⎕IO←0
            l rad←⍺
            m←(⍴⍵)⍴1
            box←{⍵÷⍥({+/,⍵}⌺(⍺ ⍺))m}
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
            ⍝ img←⍺ ⋄ x y←⍵
            ⍺⌷⍨(⍴⍺)(##.quant⍥##.linear)¨⍵
        }
    :EndNamespace
:EndNamespace