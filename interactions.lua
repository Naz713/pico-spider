function interactions_update()
 collect_bulb()
 thorn_damage()
 ant_damage()
end

function thorn_damage()
  if s.invc_t <= 0 then
    crnrs=get_sprite_corners(s.xpos, s.ypos, s.ornt)
    if fget(mget(crnrs.lx\8, crnrs.ly\8),5) or fget(mget(crnrs.hx\8, crnrs.hy\8),5) then
      spdr_damaged()
    end
  end
end

function ant_damage()
  crnrs=get_sprite_corners(s.xpos, s.ypos, s.ornt)
  for i, ant in ipairs(ants.alive) do
    if (ant.xpos>=crnrs.lx-7 and ant.xpos<=crnrs.hx ) and
        (ant.ypos>=crnrs.ly-7 and ant.ypos<=crnrs.hy ) then
      spdr_damaged()
      del(ants.alive, ant)
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
