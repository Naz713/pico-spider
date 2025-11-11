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
    s.rvel=max(s.rvel,-s.mrvel)
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
    s.xpos=min(s.xpos,s.xmax-8)
    s.xpos=max(s.xpos,s.xmin)
  else
    s.ypos+=run_vel
    s.ypos=min(s.ypos,s.ymax-8)
    s.ypos=max(s.ypos,s.ymin)
  end
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
      s.ornt=-4
      --set on the real x position, like a proper rotation
      if (abs(s.ornt)!=2) s.xpos+=8
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
      s.ornt=sgn(s.ornt)
      s.jvel*=-1
    end
    jump_pos_update(s.jvel)
  
  --jumping
  elseif not btn(x_btn) and s.jvel>0 and s.on_air then
    jump_pos_update(s.jvel)
    s.jvel*=s.drag
    if (s.jvel<1) s.jvel=0
  
  --falling
  elseif s.ypos<s.ymax and s.on_air then
    s.jvel-=s.grav
    s.jvel=max(s.jvel,-s.imp)
    jump_pos_update(s.jvel)
  end

  --asure we stay within limits
  s.xpos=max(s.xmin,s.xpos)
  s.xpos=min(s.xmax,s.xpos)
  s.ypos=max(s.ymin,s.ypos)
  s.ypos=min(s.ymax,s.ypos)
end

function jump_pos_update(jvel)
  --faliing down
  if jvel<0 then
    s.ypos-=jvel
  -- jump up-right
  elseif s.ornt==1 or abs(s.ornt)==2 then
    s.ypos-=jvel
    s.xpos+=jvel
  -- jump up-left
  elseif s.ornt==-1 or abs(s.ornt)==4 then
    s.ypos-=jvel
    s.xpos-=jvel
  elseif abs(s.ornt)==3 then
    --never should reach here
    s.ypos+=jvel
    s.jvel=-jvel
  end
end

function get_sprite_corners(x, y, orient)
  if (orient%2)==1 then
    return {lx=flr(x/8), ly=flr(y/8),
            hx=flr((x+15)/8), hy=flr((y+7)/8)}
  else
    return {lx=flr(x/8), ly=flr(y/8),
            hx=flr((x+7)/8), hy=flr((y+15)/8)}
  end
end

function limits_update()
  cnrs=get_sprite_corners(s.xpos, s.ypos, s.ornt)
  sprs={lx_ly=mget(cnrs.lx, cnrs.ly),
        hx_ly=mget(cnrs.hx, cnrs.ly),
        lx_hy=mget(cnrs.lx, cnrs.hy),
        hx_hy=mget(cnrs.hx, cnrs.hy)}
  --HIGH Y
  if fget(sprs.hx_hy,1) or fget(sprs.lx_hy,1) then
    s.ymax=cnrs.hy*8-4
  else
    s.ymax=120
    if (abs(s.ornt)==1) s.on_air=true
  end
  --LOW  X
  if fget(sprs.lx_ly,2) or fget(sprs.lx_hy,2) then
    s.xmin=cnrs.lx*8+4
  else
    s.xmin=0
    if (abs(s.ornt)==2) s.on_air=true
  end
  --LOW  Y
  if fget(sprs.hx_ly,3) or fget(sprs.lx_ly,3) then
    s.ymin=cnrs.ly*8+4
  else
    s.ymin=0
    if (abs(s.ornt)==3) s.on_air=true
  end
  --HIGH X
  if fget(sprs.hx_ly,4) or fget(sprs.hx_hy,4) then
    s.xmax=cnrs.hx*8-4
  else
    s.xmax=120
    if (abs(s.ornt)==4) s.on_air=true
  end
end

function spdr_draw()
  cls(12)
  map()
  --decide the sprite based on the position
  sprite=(flr(s.xpos)%2)*2
  
  -- horizontal orientation (odd)
  if (s.ornt%2)==1 then
    spr(sprite,s.xpos,s.ypos,2,1,
        (s.ornt<0), (abs(s.ornt)>2))
  
  -- vertical orientation (even)
  else
    spr(sprite+16,s.xpos,s.ypos,1,2,
        (abs(s.ornt)>2), (s.ornt<0))
  end 
end
