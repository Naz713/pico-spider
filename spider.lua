function ornt_btns(orient)
  if (orient%2)==1 then
    return {forw=ri_btn, bckw=le_btn}
  else
    return {forw=do_btn, bckw=up_btn}
  end 
end

function run_update()
  mv_btns=ornt_btns(s.ornt)
  --velocity update
  if btn(mv_btns.forw) then
    s.rvel+=s.racc
    s.rvel=min(s.rvel,s.mrvel)
  elseif btn(mv_btns.bckw) then
    s.rvel-=s.racc
    s.rvel=max(s.rvel,-1*s.mrvel)
  elseif s.rvel > 0 then
    s.rvel=flr(s.rvel*s.fricc)
  elseif s.rvel < 0 then
    s.rvel=ceil(s.rvel*s.fricc)
  end
  if abs(s.rvel)<1 then
    s.rvel=0
  end

  -- SIGN orientation Update
  sign_ornt()

  -- position update
  if s.rvel!=0 then
    run_pos_update(s.rvel)
  end
end
  
-- SIGN orientation Update
function sign_ornt()
  if s.rvel>0 then
    s.ornt=abs(s.ornt)
  elseif s.rvel<0 then
    s.ornt=abs(s.ornt)*-1
  end
end

--position update
function run_pos_update(run_vel)
  if (s.ornt%2)==1 then
    s.xpos+=run_vel
  else
    s.ypos+=run_vel
  end

  cord=spdr_head_crnr()
  check_wall_cornr(s, mget(cord.x\8, cord.y\8), true)

  within_pos_limits()

  cord=spdr_front_feet()
  check_inner_cornr(s, mget(cord.x\8, cord.y\8), true)
end

-- update orientation and related variables
-- when touching walls, ceiling or floor
function ornt_update()
  if (s.ornt%2)==1 then
    loc_xmax=s.xmax-8
    loc_ymax=s.ymax
  else
    loc_xmax=s.xmax
    loc_ymax=s.ymax-8
  end
  if s.ypos>=loc_ymax and s.on_air then
    s.on_air=false
    s.jvel=0
    if abs(s.ornt)!=1 then
      if s.ornt==4 then
        s.ornt=-1
      else
        s.ornt=1
      end
    end
  elseif s.xpos<=s.xmin and s.on_air then
    s.on_air=false
    s.jvel=0
    if abs(s.ornt)!=2 then
      s.ornt=-2
    end
  elseif s.xpos>=loc_xmax and s.on_air then
    s.on_air=false
    s.jvel=0
    if abs(s.ornt)!=4 then
      --set on the real x position, like a proper rotation
      -- based on orientation
      if (abs(s.ornt)!=2) s.xpos+=8
      --then update the orientation
      s.ornt=-4
      within_pos_limits()
    end
  elseif s.ypos<=s.ymin and s.on_air then
    s.on_air=false
    s.jvel=0
    if s.ornt==4 then
      s.ornt=-3
    elseif abs(s.ornt)!=3 then
      s.ornt=3
    end
  end
end

function jump_update()
  --starting jump and signal it
  if btnp(x_btn) and (not s.on_air) then
    s.on_air=true
    s.jvel=s.imp
    -- set to horizontal orientation
    if (s.ornt%2)==0 then
      s.rvel=0
      if abs(s.ornt)==2 then
        s.ornt=1
      elseif abs(s.ornt)==4 then
        s.ornt=-1
      end
    elseif abs(s.ornt)==3 then
      -- turn to ornt 1 with same sign
      s.ornt=sgn(s.ornt)
      s.jvel*=-1
    end
    jump_pos_update(s.jvel)
  
  --jumping
  elseif s.jvel>0 and s.on_air then
    jump_pos_update(s.jvel)
    s.jvel*=s.drag
    if (s.jvel<1) s.jvel=0
  
  --falling
  elseif s.ypos<s.ymax and s.on_air then
    s.jvel-=s.grav
    s.jvel=max(s.jvel,-1*s.imp)
    jump_pos_update(s.jvel)
  end
  --asure we stay within limits
  within_pos_limits()
end

function within_pos_limits()
  --asure we stay within limits
  if (s.ornt%2)==1 then
    s.xpos=min(s.xpos,s.xmax-8)
    s.xpos=max(s.xpos,s.xmin)
    s.ypos=min(s.ymax,s.ypos)
    s.ypos=max(s.ymin,s.ypos)
  else
    s.xpos=min(s.xmax,s.xpos)
    s.xpos=max(s.xmin,s.xpos)
    s.ypos=min(s.ypos,s.ymax-8)
    s.ypos=max(s.ypos,s.ymin)
  end
end

function jump_pos_update(jvel)
  --falling down
  if jvel<0 then
    pred_tray(s.xpos,s.ypos,jvel,0,-1)
    s.ypos-=jvel
  -- jump up-right
  elseif s.ornt==1 or abs(s.ornt)==2 then
    pred_tray(s.xpos,s.ypos,jvel,1,-1)
    s.xpos+=jvel
    s.ypos-=jvel
  -- jump up-left
  elseif s.ornt==-1 or abs(s.ornt)==4 then
    pred_tray(s.xpos,s.ypos,jvel,-1,-1)
    s.xpos-=jvel
    s.ypos-=jvel
  end
end

function pred_tray(x,y,vel,xdir,ydir)
  for it=vel,0,(-1*sgn(vel)) do
    limits_update(x+(it*xdir),y+(it*ydir),false)
  end  
end

function get_sprite_corners(x, y, orient)
  --Inner corners in the sprite with [0-127] coordinates
  if (orient%2)==1 then
    return {lx=(x), ly=(y),
            hx=(x+15), hy=(y+7)}
  else
    return {lx=(x), ly=(y),
            hx=(x+7), hy=(y+15)}
  end
end

function limits_update(x, y, always_update)
  cnrs=get_sprite_corners(x, y, s.ornt)
  --[[Calculated by the spider sprites' inner corners
    plus one in the direction of where its tested]]
  sprs={lx_ly=mget((cnrs.lx-1)\8, cnrs.ly\8),
        lx_hy=mget((cnrs.lx-1)\8, cnrs.hy\8),
        hx_ly=mget((cnrs.hx+1)\8, cnrs.ly\8),
        hx_hy=mget((cnrs.hx+1)\8, cnrs.hy\8),
        hy_lx=mget(cnrs.lx\8, (cnrs.hy+1)\8),
        hy_hx=mget(cnrs.hx\8, (cnrs.hy+1)\8),
        ly_lx=mget(cnrs.lx\8, (cnrs.ly-1)\8),
        ly_hx=mget(cnrs.hx\8, (cnrs.ly-1)\8)}
  --[[ The sprite flags indicate if they block movement
       in the orientation equals to its flag
       always at the start in the sprite
    Ignoring sprites with flags higher than 4]]
  --HIGH Y
  if (fget(sprs.hy_hx,1) and fget(sprs.hy_hx)<=32) or
      (fget(sprs.hy_lx,1) and fget(sprs.hy_lx)<=32) then
    s.ymax=((cnrs.hy+1)\8)*8-8
  elseif always_update then
    s.ymax=120
    if (abs(s.ornt)==1) s.on_air=true
  end
  --LOW  X
  if (fget(sprs.lx_ly,2) and fget(sprs.lx_ly)<=32) or
      (fget(sprs.lx_hy,2) and fget(sprs.lx_hy)<=32) then
    s.xmin=((cnrs.lx-1)\8)*8+8
  elseif always_update then
    s.xmin=0
    if (abs(s.ornt)==2) s.on_air=true
  end
  --LOW  Y
  if (fget(sprs.ly_hx,3) and fget(sprs.ly_hx)<=32) or
      (fget(sprs.ly_lx,3) and fget(sprs.ly_lx)<=32) then
    s.ymin=((cnrs.ly-1)\8)*8+8
  elseif always_update then
    s.ymin=0
    if (abs(s.ornt)==3) s.on_air=true
  end
  --HIGH X
  if (fget(sprs.hx_ly,4) and fget(sprs.hx_ly)<=32) or
      (fget(sprs.hx_hy,4) and fget(sprs.hx_hy)<=32) then
    s.xmax=((cnrs.hx+1)\8)*8-8
  elseif always_update then
    s.xmax=120
    if (abs(s.ornt)==4) s.on_air=true
  end
end

function spdr_head_crnr()
  if (s.ornt%2)==1 then
    -- horizontal orientation (odd)
    if s.ornt<0 then
      plus_x=-1
    else
      plus_x=16
    end
    if abs(s.ornt)==1 then
      plus_y=0
    else
      plus_y=7
    end
  else
    -- vertical orientation (even)
    if abs(s.ornt)==4 then
      plus_x=0
    else
      plus_x=7
    end
    if s.ornt<0 then
      plus_y=-1
    else
      plus_y=16
    end
  end
  return {x=s.xpos+plus_x, y=s.ypos+plus_y}
end

function spdr_front_feet()
  if (s.ornt%2)==1 then
    -- horizontal orientation (odd)
    if s.ornt<0 then
      plus_x=0
    else
      plus_x=15
    end
    if abs(s.ornt)==3 then
      plus_y=-1
    else
      plus_y=8
    end
  else
    -- vertical orientation (even)
    if abs(s.ornt)==2 then
      plus_x=-1
    else
      plus_x=8
    end
    if s.ornt<0 then
      plus_y=0
    else
      plus_y=15
    end
  end
  return {x=s.xpos+plus_x, y=s.ypos+plus_y}
end

function spdr_draw()
  -- horizontal orientation (odd)
  if (s.ornt%2)==1 then
    --decide the sprite based on the position
    sprite=(flr(s.xpos)%2)*2
    spr(sprite,s.xpos,s.ypos,
        2,1,
        (s.ornt<0), (abs(s.ornt)>2))
  
  -- vertical orientation (even)
  else
    --decide the sprite based on the position
    sprite=16+(flr(s.ypos)%2)*2
    spr(sprite,s.xpos,s.ypos,
        1,2,
        (abs(s.ornt)>2), (s.ornt<0))
  end

  --coord=spdr_head_crnr()
  --rect(coord.x,coord.y,coord.x,coord.y,10)
end
