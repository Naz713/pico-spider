function menu_update()
  if btn(o_btn) then
    time_score=time()
    spdr_setup()
    game_screen = true
  end
end

function menu_draw()
  camera()
  cls(2)
  h1=-8
  s1=8
  spr(64,s1+8 ,h1+16,1,3) -- B
  spr(65,s1+16,h1+16,1,3) -- a
  spr(66,s1+24,h1+16,1,3) -- g
  spr(67,s1+32,h1+16,1,3) -- h
  spr(69,s1+40,h1+16,1,3) -- e
  spr(69,s1+48,h1+16,1,3) -- e
  spr(72,s1+56,h1+16,1,3) -- r
  spr(65,s1+64,h1+16,1,3) -- a
  
  h2=10
  s2=14
  spr(71,s2+8 ,h2+16,1,3) -- T
  spr(67,s2+16,h2+16,1,3) -- h
  spr(75,s2+24,h2+16,1,3) -- i
  spr(69,s2+32,h2+16,1,3) -- e
  spr(70,s2+40,h2+16,1,3) -- f
  
  h3=28
  s3=20
  spr(73,s3+8 ,h3+16,1,3) -- S
  spr(74,s3+16,h3+16,1,3) -- p
  spr(75,s3+24,h3+16,1,3) -- i
  spr(68,s3+32,h3+16,1,3) -- d
  spr(69,s3+40,h3+16,1,3) -- e
  spr(72,s3+48,h3+16,1,3) -- r

  h4=80
  s4=16
  if time_score>0 then
    if s.bulbs==0 then
        print("last death on: "..time_score.."S",s4,h4-4)
    elseif s.bulbs==16 then
        print("last win on: "..time_score.."S !!!",s4,h4-4)
    end
  end

  print("use the arrows to move",s4,h4+8)
  print("press ❎ to jump",s4,h4+16)
  print("press 🅾️ (C) to start",s4,h4+24)
end