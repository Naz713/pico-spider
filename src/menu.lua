h4=80
s4=16

dial = {
  en = {
    "last death on: ",
    "last win on: ",
    "start game",
    "change language [en]",
    "how to play",
    "select with ❎ (x)",
    "use the arrows to move",
    "use left ⬅️ and right ➡️",
    "when on floor or celling",
    "use up ⬆️ and down ⬇️",
    "when on walls",
    "press ❎ to jump",
    "look for the leaf fruit",
    "see them on the lower bar",
    "fill the bar to win!!!",
    "avoid the thorns and ants",
    "they make you loose fruits",
    "if the bar empties you loose!",
    "press 🅾️ (C) to go back",
  },
  es = {
    "ultima derrota: ",
    "ultima victoria: ",
    "iniciar juego",
    "cambiar idioma [es]",
    "como jugar",
    "selecciona con ❎ (x)",
    "muevete con las flechas",
    "usa izquierda ⬅️ y derecha ➡️",
    "en el piso y el techo",
    "usa arriba ⬆️ y abajo ⬇️",
    "en las paredes",
    "usa ❎ para saltar",
    "busca los frutos de hojas",
    "veelos en la barra inferior",
    "llena la barra para ganar!!!",
    "evita las espinas y hormigas",
    "hacen que pierdas frutos",
    "si la barra se vacia piedes!",
    "usa 🅾️ (C) para regresar",
}}

avai_lan = {"en","es"}
curr_lan = 1 --sequences start on 1

title_sreen = true

arrow_pos=0
arrow_time=0

function menu_update()
  if title_sreen then
    title_update()
  else
    inst_update()
  end
end

function title_update()
  arrow_time += 2
  arrow_time %= 30
  
  if btnp(x_btn) and arrow_pos == 0 then
    time_score=time()
    spdr_setup()
    game_screen = true
    new_mstate = "game"
  
  elseif btnp(x_btn) and arrow_pos == 1 then
    curr_lan = (curr_lan+1) % count(avai_lan)
    if curr_lan == 0 then
      curr_lan = count(avai_lan)
    end
  elseif btnp(x_btn) and arrow_pos == 2 then
    title_sreen = false
  end
  
  if btnp(up_btn) then
    arrow_pos -= 1
    arrow_pos %= 3
  
  elseif btnp(do_btn) then
    arrow_pos += 1
    arrow_pos %= 3
  end

  lan = avai_lan[curr_lan]

end

function inst_update()
  if btnp(o_btn) then
    title_sreen = true
  end
end

function menu_draw()
  if title_sreen then
    title_draw()
  else
    inst_draw()
  end
end

function title_draw()
  camera()
  cls(2)
  h1=-8
  s1=8
  --Bagheera Thief Spider
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

  if time_score>0 then
    if s.bulbs==0 then
        print(dial[lan][1]..time_score.."S",s4,h4-4,8)
    elseif s.bulbs==16 then
        print(dial[lan][2]..time_score.."S !!!",s4,h4-4,10)
    end
  end

  print(dial[lan][3],s4,h4+8,7)
  print(dial[lan][4],s4,h4+16)
  print(dial[lan][5],s4,h4+24)
  print(dial[lan][6],s4,h4+32)

  spr(76+(arrow_time%2),s4-15+(arrow_time/5),h4+8+(8*arrow_pos))
end

function inst_draw()
  camera()
  cls(14)

  print(dial[lan][7],8,8,7)
  print(dial[lan][8],8,16)
  print(dial[lan][9],16,24)
  print(dial[lan][10],8,32)
  print(dial[lan][11],16,40)
  print(dial[lan][12],8,48)
  
  spr(128,8,64)
  print(dial[lan][13],16,64)
  spr(8,8,72)
  print(dial[lan][14],16,72)
  print(dial[lan][15],8,80)
  spr(160,8,88)
  print(dial[lan][16],16,88)
  spr(48,8,96)
  print(dial[lan][17],16,96)
  print(dial[lan][18],8,104)

  print(dial[lan][19],8,120)
end