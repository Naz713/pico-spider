function _init()
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

function _update()
 jump_update()
 run_update()
 ornt_update()
 --printh(s.on_air)
end

function _draw()
 spdr_draw()
end