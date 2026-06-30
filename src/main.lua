function _init()
  game_screen=false
  time_score=0.0
  cam={
    x=0,
    y=0,
    vel=0,
  }
  s={
    bulbs=0,
    maxbulbs=16,
    invc_t=0,
    --character position
    xpos=56,
    ypos=24,
    --  character orientation
    --[[ positive/negative signals
        towards where its looking
      1 floor 3 ceiling
      2 left wall 4 right wall ]]
    ornt=1,
    --screen limits
    xmax=128*8,
    xmin=0,
    ymax=32*8,
    ymin=0,
    --running variables
    rvel=0,
    racc=1,
    mrvel=5, --never 8 or more
    fricc=0.75,
    --jumping variables
    grav=3,
    jvel=0,
    imp=9,
    on_air=true,
    drag=0.7,
  }
  bulbs={
    max=16,
    alive=0
  }
  ants={
    max=8,
    mvel=3,
    acc=1,
    alive={},
    --the max distance of the character / min despawn distance
    mdist=256
  }
  spdr_setup()
end

function _update()
  if game_screen then
    game_update()
  else
    menu_update()
  end
  music_update()
end

function _draw()
  if game_screen then
    game_draw()
  else
    menu_draw()
  end
end

function game_update()
  spdr_update()
  spawns_update(s.xpos,s.ypos)
  interactions_update()
  cam_update()
end

function cam_update()
  acc=1
  maxcamvel=s.imp
  mincamvel=3
  cord=spdr_head_crnr()

  xdiff=abs((cord.x-64) - cam.x)*0.25
  ydiff=abs((cord.y-56) - cam.y)*0.25

  if (xdiff>cam.vel) or (ydiff>cam.vel) then
    cam.vel+=acc
    cam.vel=min(cam.vel,maxcamvel)
  end

  if (xdiff<cam.vel) and (ydiff<cam.vel) then
    cam.vel-=acc
    cam.vel=max(cam.vel,mincamvel)
  end

  xdiff=min(cam.vel, xdiff)*sgn((cord.x-64) - cam.x)
  ydiff=min(cam.vel, ydiff)*sgn((cord.y-56) - cam.y)

  cam.x=min(max(cam.x+xdiff,0),112*8)
  cam.y=min(max(cam.y+ydiff,0),136)
end

function fruit_draw()
  camera()
  -- Draw inferior menu to show the collected beltian bodies (fruit)
  rectfill(0,120,127,127, 2 --[[Deep Purple]] )
  rect(0,120,127,127, 6 --[[Gray]] )
  for i=1,s.bulbs do
   spr(8,i*8-8,120)
  end
 end

function game_draw()
  camera(cam.x,cam.y)
  cls(12)
  map(0,0,0,0,128,32)
  
  spdr_draw()
  draw_ants()
  fruit_draw()
end
