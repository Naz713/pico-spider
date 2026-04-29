function spawns_update(sx,sy)
  r=8 --radius of checks for spawning (screen 16)
  x=flr(sx/8)
  y=flr(sy/8)
  for ix=x-r,x+r-1 do
    for iy=y-r,y+r-1 do
      bulb_spawn(ix,iy)
      ant_emerge(ix,iy)
    end
  end
  ants_move(sx,sy)
end

function bulb_spawn(x,y)
  map_sprt=mget(x,y)
  spwnp=0.001
  -- 6 flag to indicate empty bulb sprites (7 full)
  if fget(map_sprt,6) and bulbs.alive < bulbs.max and
      rnd()<=spwnp then
    mset(x,y, map_sprt-16)
    bulbs.alive+=1
  end
end

function bulb_despawn(x,y)
  map_sprt=mget(x,y)
  -- 7 flag to indicate empty bulb sprites (6 empty)
  if fget(map_sprt,7) then
    mset(x,y, map_sprt+16)
    bulbs.alive-=1
  end
end

function ant_emerge(ix,iy)
  map_sprt=mget(ix,iy)
  spwnp=0.01
  -- 5 flag to indicate spawn sprites
  if fget(map_sprt,5) and #(ants.alive) < ants.max and
      rnd()<=spwnp then
    -- flags 1,2:Orientation (as the character) to where it has a base to solid
    ant_ornt=shr(fget(map_sprt)%8,1) -- turn the second and third bit into an number: the ornt
    return add(ants.alive, {xpos=(ix*8),ypos=(iy*8), vel=0, ornt=ant_ornt})
  end
end

function draw_ants()
  for ant in all(ants.alive) do
    horspr=48+(ant.xpos%2)
    verspr=50+(ant.ypos%2)

    -- horizontal orientation (odd)
    if (ant.ornt%2)==1 then
      spr(horspr, ant.xpos, ant.ypos,1,1,
          (ant.ornt<0), (abs(ant.ornt)>2))
    
    -- vertical orientation (even)
    else
      spr(verspr, ant.xpos, ant.ypos,1,1,
          (abs(ant.ornt)>2), (ant.ornt<0))
    end
  end
end

function ants_move(sx,sy)
  for i, ant in ipairs(ants.alive) do
    -- Calculate distance with the sqr "circle" distance (max function)
    if max(abs(sx - ant.xpos), abs(sy - ant.ypos)) >= ants.mdist then
      del(ants.alive, ant)
    else
      if (ant.ornt%2)==1 then
      -- horizontal orientation (odd)
        ant.vel += ants.acc*sgn(sx - ant.xpos)
        ant.vel = min(abs(ant.vel),ants.mvel)*sgn(ant.vel)
        ant.xpos += ant.vel
      else
      -- vertical orientation (even)
        ant.vel += ants.acc*sgn(sy - ant.ypos)
        ant.vel = min(abs(ant.vel),ants.mvel)*sgn(ant.vel)
        ant.ypos += ant.vel
      end
    end
  end
end
