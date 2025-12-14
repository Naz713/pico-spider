function spawns_update(sx,sy)
  r=8 --radius of checks for (spawns screen 16l)
  x=flr(sx/8)
  y=flr(sy/8)
  for ix=x-r,x+r-1 do
    for iy=y-r,y+r-1 do
      bulb_spawn(ix,iy)
      ant_emerge(ix,iy)
    end
  end
end

function draw_ants()
    
end

function bulb_spawn(x,y)
  map_sprt=mget(x,y)
  spwnp=0.01
  -- 6 flag to indicate empty bulb sprites (7 full)
  if fget(map_sprt,6) and bulbs.alive < bulbs.max and
      rnd()<=spwnp then
    mset(x,y, map_sprt-16)
    bulbs.alive+=1
  end
end

function ant_emerge(ix,iy)
  map_sprt=mget(ix,iy)
  spwnp=0.01
  -- 5 flag to indicate spawn sprites
  if fget(map_sprt,5) and #(ants.alive) < bulbs.max and
      rnd()<=spwnp then
    --TODO consider other all aorintation posibilities
    --for both spawn sprite and ant sprite
    add(ants.alive, {x=(ix*8)-4,y=(iy*8), ornt=1})
  end
end

function ants_move()
    
end
