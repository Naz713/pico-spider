function spawns_update(sx,sy)
  ants_move(sx,sy)
  bulb_spawn(sx,sy)
  ant_emerge(sx,sy)
end

function bulb_spawn(sx,sy)
  spwnp=0.001
  x=flr(sx/8)

  for ix=max(x-32,0),max(x-16,0) do
    for iy=0,31 do
      map_sprt=mget(ix,iy)

      -- 6 flag to indicate empty bulb sprites (7 full)
      if fget(map_sprt,6) and bulbs.alive < bulbs.max and rnd()<=spwnp then
        mset(ix,iy, map_sprt-16)
        bulbs.alive+=1
      end
    end
  end
  for ix=min(x+16,127),min(x+32,127) do
    for iy=0,31 do
      map_sprt=mget(ix,iy)

      -- 6 flag to indicate empty bulb sprites (7 full)
      if fget(map_sprt,6) and bulbs.alive < bulbs.max and rnd()<=spwnp then
        mset(ix,iy, map_sprt-16)
        bulbs.alive+=1
      end
    end
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

function ant_emerge(sx,sy)
  spwnp=0.001
  r=8 --radius of checks for spawning (screen 16)

  x=flr(sx/8)
  y=flr(sy/8)
  for ix=x-r,x+r do
    for iy=y-r,y+r do
      map_sprt=mget(ix,iy)
      
      -- 5 flag to indicate spawn sprites
      if fget(map_sprt,5) and #(ants.alive) < ants.max and rnd()<=spwnp then
        
        -- flags 1,2:Orientation (as the character) to where it has a base to solid
        ant_ornt=shr(fget(map_sprt)%8,1) -- turn the second and third bit into an number: the ornt
        return add(ants.alive, {xpos=(ix*8),ypos=(iy*8), rvel=0, ornt=ant_ornt})
      end
    end
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
    --coord=ant_front_down(ant)
    --rect(coord.x,coord.y,coord.x,coord.y,10)

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
        ant.rvel += ants.acc*sgn(sx - ant.xpos)
        ant.rvel = min(abs(ant.rvel),ants.mvel)*sgn(ant.rvel)
        ant.xpos += ant.rvel
      else
      -- vertical orientation (even)
        ant.rvel += ants.acc*sgn(sy - ant.ypos)
        ant.rvel = min(abs(ant.rvel),ants.mvel)*sgn(ant.rvel)
        ant.ypos += ant.rvel
      end
      ant.ornt = abs(ant.ornt)*sgn(ant.rvel)

      cord=ant_front_down(ant)
      check_inner_cornr(ant, mget(cord.x\8, cord.y\8), false)

      cord=ant_ahead(ant)
      check_wall_cornr(ant, mget(cord.x\8, cord.y\8), false)
      fall_into_wall(ant) --if the ant was left in the air correct to floor

      --printh(ant.xpos..","..ant.ypos.."|"..ant.ornt.." "..ant.rvel)
    end
  end
end

function ant_ahead(ant)
  if (ant.ornt%2)==1 then
    -- horizontal orientation (odd)
    if ant.ornt<0 then
      plus_x=-1
    else
      plus_x=8
    end
    if abs(ant.ornt)==1 then
      plus_y=4
    else
      plus_y=3
    end
  else
    -- vertical orientation (even)
    if abs(ant.ornt)==4 then
      plus_x=4
    else
      plus_x=3
    end
    if ant.ornt<0 then
      plus_y=-1
    else
      plus_y=8
    end
  end
  return {x=ant.xpos+plus_x, y=ant.ypos+plus_y}
end

function check_wall_cornr(ant, ahead_spr, l_spr)
  minvel=3
  if (abs(ant.ornt)%2==1 and ant.ornt<0)
    and (fget(ahead_spr,2) and fget(ahead_spr)<=32) then
    -- Horizontal left heading
      if ant.ornt==-1 then
        ant.ypos -= (-1*ant.xpos)%8
        if (ant.xpos%8!=0) ant.xpos = (ant.xpos\8)*8+8
        ant.ornt=-2
      elseif ant.ornt==-3 then
        ant.ypos += (-1*ant.xpos)%8
        if (ant.xpos%8!=0) ant.xpos = (ant.xpos\8)*8+8
        ant.ornt=2
        ant.rvel = -1*ant.rvel
      end

  elseif (abs(ant.ornt)%2==0 and ant.ornt<0)
    and (fget(ahead_spr,3) and fget(ahead_spr)<=32) then
    -- Vertical up heading
      if ant.ornt==-2 then
        ant.xpos += (-1*ant.ypos)%8
        if (ant.ypos%8!=0) ant.ypos = (ant.ypos\8)*8+8
        ant.ornt=3
        ant.rvel = -1*ant.rvel
      elseif ant.ornt==-4 then
        ant.xpos -= (-1*ant.ypos)%8
        if (ant.ypos%8!=0) ant.ypos = (ant.ypos\8)*8+8
        ant.ornt=-3
      end

  elseif (abs(ant.ornt)%2==1 and ant.ornt>0)
    and (fget(ahead_spr,4) and fget(ahead_spr)<=32) then
    -- Horizontal right heading
      if ant.ornt==1 then
        ant.ypos -= ant.xpos%8
        ant.xpos = (ant.xpos\8)*8
        ant.ornt=-4
        ant.rvel = -1*ant.rvel
      elseif ant.ornt==3 then
        ant.ypos += ant.xpos%8
        ant.xpos = (ant.xpos\8)*8
        ant.ornt=4
      end
      if l_spr then
        ant.xpos+=8
      end

  elseif (abs(ant.ornt)%2==0 and ant.ornt>0)
    and (fget(ahead_spr,1) and fget(ahead_spr)<=32) then
    -- Vertical down heading
      if ant.ornt==2 then
        ant.xpos += ant.ypos%8
        ant.ypos = (ant.ypos\8)*8
        ant.ornt=1
      elseif ant.ornt==4 then
        ant.xpos -= ant.ypos%8
        ant.ypos = (ant.ypos\8)*8
        ant.ornt=-1
        ant.rvel = -1*ant.rvel
      end
      if l_spr then
        ant.ypos+=8
      end
  end
end

function fall_into_wall(ant)
  cord=ant_front_down(ant)

  down_spr=mget(cord.x\8, cord.y\8)
  if not fget(down_spr,abs(ant.ornt)) then
    if abs(ant.ornt) == 1 then
      ant.ypos += 8
    elseif abs(ant.ornt) == 2 then
      ant.xpos -= 8
    elseif abs(ant.ornt) == 3 then
      ant.ypos -= 8
    elseif abs(ant.ornt) == 4 then
      ant.xpos += 8
    end
  end
end

function ant_front_down(ant)
  if (ant.ornt%2)==0 then
    -- vertical orientation (even)
    if abs(ant.ornt)==2 then
      plus_x=-1
    else
      plus_x=8
    end
    if ant.ornt<0 then
      plus_y=-1
    else
      plus_y=8
    end
  else
    -- horizontal orientation (odd)
    if ant.ornt<0 then
      plus_x=-1
    else
      plus_x=8
    end
    if abs(ant.ornt)==3 then
      plus_y=-1
    else
      plus_y=8
    end
  end
  return {x=ant.xpos+plus_x, y=ant.ypos+plus_y}
end

function check_inner_cornr(ant, front_down_spr, l_spr)

  if ant.ornt==3
      and (not fget(front_down_spr,3) and fget(front_down_spr)<=32) then
    ant.ypos -= ant.xpos%8
    ant.xpos = (ant.xpos\8)*8+8
    ant.ornt=-2
    ant.rvel = -1*ant.rvel
    if l_spr then
      ant.xpos+=8
    end

  elseif ant.ornt==1
      and (not fget(front_down_spr,1) and fget(front_down_spr)<=32) then
    ant.ypos += ant.xpos%8
    ant.xpos = (ant.xpos\8)*8+8
    ant.ornt=2
    if l_spr then
      ant.xpos+=8
    end

  elseif ant.ornt==4
      and (not fget(front_down_spr,4) and fget(front_down_spr)<=32) then
    ant.xpos += ant.ypos%8
    ant.ypos = (ant.ypos\8)*8+8
    ant.ornt=3
    if l_spr then
      ant.ypos+=8
    end

  elseif ant.ornt==2
      and (not fget(front_down_spr,2) and fget(front_down_spr)<=32) then
    ant.xpos -= ant.ypos%8
    ant.ypos = (ant.ypos\8)*8+8
    ant.ornt=-3
    ant.rvel = -1*ant.rvel
    if l_spr then
      ant.ypos+=8
    end

  elseif ant.ornt==-3
      and (not fget(front_down_spr,3) and fget(front_down_spr)<=32) then
    ant.ypos -= ant.xpos%8
    ant.xpos = (ant.xpos\8)*8
    ant.ornt=-4

  elseif ant.ornt==-1
      and (not fget(front_down_spr,1) and fget(front_down_spr)<=32) then
    ant.ypos += ant.xpos%8
    ant.xpos = (ant.xpos\8)*8
    ant.ornt=4
    ant.rvel = -1*ant.rvel

  elseif ant.ornt==-4
      and (not fget(front_down_spr,4) and fget(front_down_spr)<=32) then
    ant.xpos += ant.ypos%8
    ant.ypos = (ant.ypos\8)*8
    ant.ornt=1
    ant.rvel = -1*ant.rvel

  elseif ant.ornt==-2
      and (not fget(front_down_spr,2) and fget(front_down_spr)<=32) then
    ant.xpos -= ant.ypos%8
    ant.ypos = (ant.ypos\8)*8
    ant.ornt=-1
  end
end

