function interactions_update()
 collect_bulb()
 thorn_damage()
 ant_damage()
end

function thorn_damage()
    
end

function ant_damage()
    
end

function collect_bulb()
  sc=spdr_head_crnr()
  x=sc.x\8
  y=sc.y\8
  map_sprt=mget(x,y)
  if fget(map_sprt,7) then
    bulb_despawn(x,y)
    s.bulbs+=1
    s.bulbs=min(s.bulbs, s.maxbulbs)
  end
end
