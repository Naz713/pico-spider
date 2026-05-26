function interactions_update()
 collect_bulb()
 thorn_damage()
 --ant_damage()
end

function thorn_damage()
  if s.invc_t <= 0 then
    crnrs=get_sprite_corners(s.xpos\8, s.ypos\8, s.ornt)
    if fget(mget(crnrs.lx, crnrs.ly),5) or fget(mget(crnrs.hx, crnrs.hy),5) then
      spdr_damaged()
    end
  end
end

function ant_damage()
  crnrs=get_sprite_corners(s.xpos\8, s.ypos\8, s.ornt)
  for i, ant in ipairs(ants.alive) do
    -- Calculate distance with the sqr "circle" distance (max function)
    if max(abs(s.xpos - ant.xpos), abs(s.ypos - ant.ypos)) >= ants.mdist then
      printh("  ")
    end
  end
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
    s.invc_t=0
  end
end
