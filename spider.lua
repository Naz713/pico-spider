function spdr_init()
  s={
    sprite=0,
    --character position
    xpos=85,
    ypos=32,
    --  character orientation
    --[[ positive/negative signals
        towards where its looking
      1 floor 3 ceiling
      2 left wall 4 right wall ]]
    ornt=1,
    --screen limits
    maxpos=120,
    minpos=0,
    --running variables
    rvel=0,
    racc=1,
    mrvel=6,
    fricc=0.75,
    --jumping variables
    grav=3,
    jvel=0,
    imp=14,
    on_air=true,
    drag=0.5,
  }
end

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
  elseif abs(s.rvel)<1 then
    s.rvel=0
  elseif s.rvel > 0 then
    s.rvel=flr(s.rvel*s.fricc)
  elseif s.rvel < 0 then
    s.rvel=ceil(s.rvel*s.fricc)
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
    s.xpos=min(s.xpos,s.maxpos)
    s.xpos=max(s.xpos,s.minpos)
  else
    s.ypos+=run_vel
    s.ypos=min(s.ypos,s.maxpos)
    s.ypos=max(s.ypos,s.minpos)
  end
end

-- update orientation and related variables
-- when touching walls, ceiling or floor
function ornt_update()
  if s.ypos==s.maxpos and s.on_air then
    s.on_air=false
    s.jvel=0
    if s.ornt==4 then
      s.ornt=-1
    else
      s.ornt=1
    end
  elseif s.xpos==s.minpos and s.on_air then
    s.on_air=false
    s.jvel=0
    if s.ornt==1 then
      s.ornt=-2
    elseif abs(s.ornt)!=2 then
      s.ornt=2
    end
  elseif s.xpos==s.maxpos and s.on_air then
    s.on_air=false
    s.jvel=0
    if s.ornt==1 then
      s.ornt=-4
    elseif abs(s.ornt)!=4 then
      s.ornt=4
    end
  elseif s.ypos==s.minpos and s.on_air then
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
  elseif s.ypos<s.maxpos and s.on_air then
    s.jvel-=s.grav
    s.jvel=max(s.jvel,-s.imp)
    jump_pos_update(s.jvel)
  end
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

  --asure we stay within limits
  s.xpos=max(s.minpos,s.xpos)
  s.xpos=min(s.maxpos,s.xpos)
  s.ypos=max(s.minpos,s.ypos)
  s.ypos=min(s.maxpos,s.ypos)
end

function spdr_draw()
  cls(2)
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
