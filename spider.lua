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
 grav=4
 jvel=0
 chrg=4
 mjvel=14
end

function update_sprite()
 sprite+=2
 if (sprite>2) sprite=0
end

function run_update()
 --velocity update
 if btn(➡️) then
 	rvel+=racc
 	rvel=min(rvel,mrvel)
 elseif btn(⬅️) then
  rvel-=racc
  rvel=max(rvel,-mrvel)
 elseif abs(rvel)<1 then
  rvel=0
 else
  rvel/=3
 end
 --position update
 if rvel!=0 then
  xpos+=rvel
  update_sprite()
 end
 if rvel>0 then
  ornt=abs(ornt)
 elseif rvel<0 then
  ornt=abs(ornt)*-1
 end
 xpos=min(xpos,104)
 xpos=max(xpos,8)
end

function jump_update()
 --jumping
 if not btn(⬆️)
    and jvel>0 then
  ypos-=jvel
  ypos=max(minpos,ypos)
  ypos=min(maxpos,ypos)
  jvel*=0.75
 	if (jvel<2) jvel=0
 --falling
 elseif ypos<maxpos then
  jvel-=grav
  jvel=max(jvel,-mjvel)
  
  ypos-=jvel
  ypos=max(minpos,ypos)
  ypos=min(maxpos,ypos)
 --charging
 elseif btn(⬆️) then
  if (jvel<0) jvel=0
  jvel+=chrg
  jvel=min(jvel,mjvel)
 end
end

function spdr_draw()
 cls(7)
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
