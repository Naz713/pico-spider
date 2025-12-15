function _init()
  s={
    bulbs=0,
    invc_t=0,
    sprite=0,
    --character position
    xpos=64,
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
    max=16,
    alive={}
  }
end

function _update()
  limits_update(s.xpos, s.ypos, true)
  jump_update()
  run_update()
  ornt_update()
  --printh(s.xmax..", "..s.xmin..", "..s.ymax..", "..s.ymin..", ")
  spawns_update(s.xpos,s.ypos)
end

function _draw()
 spdr_draw()
 draw_ants()
end