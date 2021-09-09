readpnm=:3 : 0
  type=. 0 1 { y
  if. (<type) e. 'P4';'P5';'P6' do.
    data=.3 }. y
    'y x'=. _ ". (i.&LF{.]) data
    select. type
    case. 'P4' do.
      data=., (8$2)#: a.i. (>:@i.&LF}.]) data
      y {." 1(x,(>.&.(%&8)) y)$data
    case. 'P5' do.
      (x,y)$ a.i. (>:@i.&LF}.])^: 2 data
    case. 'P6' do.
      256#.(x,y,3)$ a.i. (>:@i.&LF}.])^: 2 data
    end.
  else.
    smoutput 'Error: unknown magic'
    return.
  end.
)

writepnm=:4 : 0
  spec=.y
  img=.x
  if. -. (<spec) e. 'P4';'P5';'P6' do.
    smoutput 'Error. unknow file type'
    return.
  else.
    hdr=.spec,LF
    select. spec
    case. 'P4' do.
      hdr=.hdr,":'x y'=.|.$img
      img=._8 #.\ ,(<.&.(%&8) x) {.&.|: img
    fcase. 'P6' do.
      img=.,(3$256)#:img
    case. 'P5' do.
      hdr=.hdr,(":'x y'=.|.$img),LF,'255'
      img=.,img
    end.
    hdr,LF,img { a.
  end.
)