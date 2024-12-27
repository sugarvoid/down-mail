end_text_l1=""
end_text_l2=""

endings={
    "local mailman goes missing",
    "local mailman turns to red splat",
    "local mailman missing",
    "dog claims mailman's life",
    "mailman fired",
    "mailman quits, buys city",
}

function draw_gameover()
    cls(7)
    spr(192,32,8,8,2)
    print("$0.25",6,10,5)
    rect(4,30,124,120,5)
    spr(end_spr[1],80,34,4,4)
    print("game over",game_over_x,1,0)
    print(end_text_l1,10,40,0)
end

function update_gameover()
    game_over_x+=1
    if game_over_x==130 then
        game_over_x=-30
    end
end
