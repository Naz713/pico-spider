function spdr_init()
  sprite=0
  --character position
  xpos=85
  ypos=120
  --  character orientation
  --[[ positive/negative signals
      towards where its looking
    1 floor 3 ceiling
    2 left wall 4 right wall ]]
  ornt=1
  --screen limits
  maxpos=120
  minpos=8
  --running variables
  rvel=0
  racc=1
  mrvel=6
  --jumping variables
  grav=3
  jvel=0
  chrg=4
  mjvel=14
end

function ornt_btns()
  if (ornt%2)==1 then
    return {forw=ri_btn, bckw=le_btn}
  else
    return {forw=do_btn, bckw=up_btn}
  end 
end

function run_update()
  mv_btns=ornt_btns()
  --velocity update
  if btn(mv_btns.forw) then
    rvel+=racc
    rvel=min(rvel,mrvel)
  elseif btn(mv_btns.bckw) then
    rvel-=racc
    rvel=max(rvel,-mrvel)
  elseif abs(rvel)<1 then
    rvel=0
  elseif rvel > 0 then
    rvel=flr(rvel/3)
  elseif rvel < 0 then
    rvel=ceil(rvel/3)
  end
  -- position update
  if rvel!=0 then
    pos_update(rvel)
  end
  
  -- SIGN orientation Update
  if rvel>0 then
    ornt=abs(ornt)
  elseif rvel<0 then
    ornt=abs(ornt)*-1
  end
end

--position update
function pos_update(run_vel)
  if (ornt%2)==1 then
    xpos+=run_vel
    xpos=min(xpos,112)
    xpos=max(xpos,0)
  else
    ypos+=run_vel
    ypos=min(ypos,112)
    ypos=max(ypos,0)
  end
end

-- update ornt when touching walls, ceiling or floor
function ornt_update()
  if ypos==112 and abs(ornt)!=1 then
    if ornt==4 then
      ornt=-1
    else
      ornt=1
    end
  elseif xpos==0 and abs(ornt)!=2 then
    if ornt==1 then
      ornt=-2
    else
      ornt=2
    end
  elseif ypos==0 and abs(ornt)!=3 then
    if ornt==4 then
      ornt=-3
    else
      ornt=3
    end
  elseif xpos==112 and abs(ornt)!=4 then
    if ornt==1 then
      ornt=-4
    else
      ornt=4
    end
  end
end

function jump_update()
  --jumping
  if not btn(x_btn)
      and jvel>0 then
    ypos-=jvel
    ypos=max(minpos,ypos)
    ypos=min(maxpos,ypos)
    jvel*=0.75
    if (jvel<2) jvel=0
  
    --falling
  elseif ypos<maxpos and abs(ornt)==1 then
    jvel-=grav
    jvel=max(jvel,-mjvel)
    
    ypos-=jvel
    ypos=max(minpos,ypos)
    ypos=min(maxpos,ypos)
  
    --charging
  elseif btn(x_btn) then
    if (jvel<0) jvel=0
    jvel+=chrg
    jvel=min(jvel,mjvel)
  end
end

function spdr_draw()
  cls(2)
  sprite=(flr(xpos)%2)*2
  
  -- horizontal orientation (odd)
  if (ornt%2)==1 then
    spr(sprite,xpos,ypos,2,1,
        (ornt<0), (abs(ornt)>2))
  
  -- vertical orientation (even)
  else
    spr(sprite+16,xpos,ypos,1,2,
        (abs(ornt)>2), (ornt<0))
  end 
end
