function _init()
  s={
    bulbs=4,
    maxbulbs=16,
    invc_t=0,
    sprite=0,
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
    xmax=120,
    xmin=0,
    ymax=120,
    ymin=0,
    --running variables
    rvel=0,
    racc=1,
    mrvel=7,
    fricc=0.75,
    --jumping variables
    grav=3,
    jvel=0,
    imp=13,
    on_air=true,
    drag=0.5,
  }
  bulbs={
    max=16,
    alive=0
  }
  ants={
    max=1,
    mvel=3,
    acc=1,
    alive={},
    --the max distance of the character / min despawn distance
    mdist=128
  }
end

 function menu_draw()
    --TODO consider a lazy following camara
  cls(12)
  map(0,0,0,0,16,15)

  -- Draw inferior menu to show the collected beltian bodies
  rectfill(0,120,127,127, 2 --[[Deep Purple]] )
  rect(0,120,127,127, 6 --[[Gray]] )
  for i=1,s.bulbs do
   spr(64,i*8-8,120)
  end
 end

function _update()
  limits_update(s.xpos, s.ypos, true)
  jump_update()
  run_update()
  ornt_update()
  --printh(s.xmax..", "..s.xmin..", "..s.ymax..", "..s.ymin..", ")
  spawns_update(s.xpos,s.ypos)
  interactions_update()
end

function _draw()
 menu_draw()
 spdr_draw()
 draw_ants()
end