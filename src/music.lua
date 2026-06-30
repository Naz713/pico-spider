
trans_frames=5
trans_ms = 0
music_states = {menu=0,game=0,low=1,high=2}

curr_mstate = "game"
new_mstate = "menu"
curr_transf = 0

function music_update()
    if curr_transf > 0 then
        curr_transf -=1
    end

    if (curr_mstate != new_mstate) and curr_transf <= 0 then
        curr_transf = trans_frames
        music(-1,trans_ms)
    end

    if (curr_mstate != new_mstate) and (curr_transf == 1) then
        music(music_states[new_mstate],trans_ms)
        curr_mstate = new_mstate
        curr_transf = 0
    end
end