is_debug = false
map_y = 0
damaged_mb = 0
game_over_x = -10
score = 0
bouns_timer = 0
deliveries = { 0, 0, 0 }
goto_bonus_tmr = 0
offset = 0
level_length = 13 --TODO: Put back 30
bouns_length = 2 --TODO: Put back 10
ending = 0
end_spr = { 64, 68, 72, 76, 140 }
objects = { back = {}, front = {} }
day = 1
days = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }

local good_score = 1000 --TODO: Replace

clock = {
    seconds = 0,
    t = 0,
    is_running = false,
    update = function(self)
        if self.is_running then
            self.t += 1
            if self.t >= 30 then
                self:tick()
            end
        end
    end,
    tick = function(self)
        self.seconds += 1
        self.t = 0
    end,
    reset = function(self)
        self.is_running = false
        self.t = 0
        self.seconds = 0
    end,
    stop = function(self)
        self:reset()
    end,
    start = function(self)
        self.is_running = true
    end
}

intro_t = 30 * 6
day_t = 30 * 6
post_t = 30 * 8
gamestates = {
    title = 0,
    how_to = 1,
    day_title = 2,
    game = 3,
    bonus = 4,
    gameover = 5,
    post_day = 6,
}
g_state = nil
deliveries_needed = 6
deliveries_left = deliveries_needed

end_text_l1 = ""
end_text_l2 = ""
ending_idx = 0

endings = {
    { "city mourns",       "loss of mailman" },
    { "local mailman",     "goes missing" },
    { "mailman fired",     "" },
    { "mailman quits,",    "buys city" },
    { "mediocre mailman,", "does job" },
}

function update_objects()
    for o in all(objects.front) do
        o:update()
    end
    for o in all(objects.back) do
        o:update()
    end
end

function draw_objects()
    for o in all(objects.front) do
        o:draw()
    end
end

function restart_game()
    day = 1
    deliveries_left = deliveries_needed
    deliveries = { 0, 0, 0 }
    intro_t = 30 * 6
    day_t = 30 * 3
    post_t = 30 * 8
    spawner:reset()
    --set_customers()
    score = 0
    init_wind()
    p1 = init_player()
    mb_tracker = {0,0}
    change_state(gamestates.title)
end

function _init()
    poke(0x5f5c, 255)


    restart_game()
end

function _update()
    check_input()



    if g_state == gamestates.title then
    --elseif g_state == gamestates.how_to then
        --update_intro()
    elseif g_state == gamestates.day_title then
        update_day()
    elseif g_state == gamestates.game then
        update_play()
    elseif g_state == gamestates.bonus then
        update_bonus()
    elseif g_state == gamestates.post_day then
        update_postday()
    elseif g_state == gamestates.gameover then
        update_gameover()
    end
end

function _draw()
    
    if g_state == gamestates.title then
        draw_title()
    elseif g_state == gamestates.how_to then
        draw_howto()
    elseif g_state == gamestates.day_title then
        draw_day()
    elseif g_state == gamestates.game then
        screen_shake()
        draw_play()
    elseif g_state == gamestates.bonus then
        draw_bonus()
    elseif g_state == gamestates.gameover then
        draw_gameover()
    elseif g_state == gamestates.post_day then
        draw_postday()
    end

    if is_debug then
        print("mem: " .. flr(stat(0)) .. "kb", 10, 0, 8)
        print("cpu: " .. stat(1) * 100 .. "%", 10, 8, 8)
    end

    print(clock.seconds, 8, 0)
end

function check_input()
    if btnp(🅾️) then
        if g_state == gamestates.title then
            g_state = gamestates.day_title
            -- elseif g_state == gamestates.how_to then
            --     intro_t = 0
        elseif g_state == gamestates.day_title then
            day_t = 0
        elseif g_state == gamestates.post_day then
            post_t = 0
        elseif g_state == gamestates.game then
            p1:throw()
        elseif g_state == gamestates.bonus then
            p1:throw()
        elseif g_state == gamestates.gameover then
            restart_game()
        end
    end

    if btn(➡️) then
        p1:move("r")
    elseif btn(⬅️) then
        p1:move("l")
    end


    if btnp(⬆️) then
        p1:update_chute(true)
        --p1.is_chute_open = true
        --p1.speed = 1
    elseif btnp(⬇️) then
        p1:update_chute(false)
        --p1.is_chute_open = false
        --p1.speed = 2
    end

    if btnp(❎) then
        if g_state == gamestates.title then
            change_state(gamestates.how_to)
        elseif g_state == gamestates.how_to then
            change_state(gamestates.title)
        elseif g_state == gamestates.bonus then
            bouns_timer = 0
        elseif g_state == gamestates.day_title then
        elseif g_state == gamestates.game then
            clock.seconds = level_length
        elseif g_state == gamestates.gameover then

        end
    end
end

function update_play()
    clock:update()

    if clock.seconds >= level_length then
        clock:stop()
        print_debug("level over")
        goto_bonus_tmr = 60
        sfx(2)
        clear_objs()
        spawner.running = false
        clock:reset()
        clock:start()
    end




    p1:update()
    update_particles()
    update_objects()
    update_letters()
    for t in all(twisters) do
        t:update()
    end
    for d in all(dogs) do
        d:update()
    end

    map_y += .2

    if flr(map_y) == 17 then
        map_y = 0
    end



    spawner:update()

    if goto_bonus_tmr > 0 then
        goto_bonus_tmr -= 1
        if goto_bonus_tmr == 0 then
            goto_bonus()
        end
    end
end

-- function update_intro()
--     intro_t -= 1
--     if intro_t <= 0 then
--         spawner:start()
--         start_level()
--         change_state(gamestates.game)
--     end
-- end

function update_postday()
    post_t -= 1
    if post_t <= 0 then
        change_state(gamestates.game)
        --deliveries = { 0, 0, 0 }
    end
end

function update_day()
    day_t -= 1
    if day_t <= 0 then
        spawner:start()
        start_level()
        change_state(gamestates.game)
        --TODO: Make better music
        --music(1)
    end
end

function update_bonus()

    clock:update()

    if clock.seconds >= bouns_length then
        clock:stop()

        mailboxes = {}
        advance_day()

    end



    -- bouns_timer -= 1
    -- if bouns_timer <= 0 then
    --     mailboxes = {}
    --     advance_day()
    --         --if day == 3 then
    --         -- if deliveries[1] == (deliveries_needed * (days_needed)) then
    --         --     end_text = endings[4]
    --         --     ending_idx = 4
    --         -- else
    --         --     end_text = endings[5]
    --         --     ending_idx = 5
    --         -- end
    --         --goto_gameover(4)
    --         --end
    -- end
    p1:update()
    update_letters()
    update_particles()
    --update_rings()
    spawner:update()
end

function draw_play()
    cls(0)
    for o in all(objects.back) do
        o:draw()
    end

    p1:draw()
    draw_particles()

    for o in all(objects.front) do
        o:draw()
    end
    for t in all(twisters) do
        t:draw()
    end
    for mb in all(mailboxes) do
        mb:draw()
    end
    draw_letters()
    for r in all(rocks) do
        r:draw()
    end
    for d in all(dogs) do
        d:draw()
    end

    map(0, map_y)
    draw_gui()

    if debug then
        for k, v in ipairs(lanes) do
            if lanes[k][2] == true then
                circfill(lanes[k][1] + 4, 119, 2, 10)
            end
        end
    end
end

function draw_title()
    cls()
    sspr(64, 96, 32, 16, 36, 20, 32*2, 16*2)
    sspr(64, 112, 32, 16, 36, 20+22, 32*2, 16*2)
    --spr(200, 48, 34, 4, 2)
    --spr(232, 48, 34 + 10, 4, 2)
    --print("down mail", hcenter("down mail"), 50, 0)
    print("🅾️ play", hcenter("🅾️ play"), 75, 7)
    print("❎ info", hcenter("❎ info"), 83, 7)

end

function draw_howto()
    cls()

    print("customers", hcenter("customers"), 22, 7)
    pal(6, 12)
    
    sspr(56, 8, 8, 8, 55, 27, 16, 16)
    pal()


    print("non-customers", hcenter("non-customers"), 52, 7)

 
    pal(6, 2)

    
    
    
    sspr(56, 8, 8, 8, 55, 57, 16, 16)
    pal()

    print("bonus", hcenter("bonus"), 82, 7)
    pal(6, 10)
    sspr(56, 8, 8, 8, 55, 87, 16, 16)
    pal()


    print("bonus", hcenter("bonus"), 82, 7)

    print("❎ back", 8, 120, 7)
end

function draw_bonus()
    cls(0)
    map(16, 0)
    p1:draw()
    draw_particles()
    draw_letters()
    draw_gui()
    --rectfill(17, 10, 17 + flr(bouns_timer / 10) * 3, 13, 3)
    --rect(17, 9, 109, 14, 7)
    print("bonus", 50, 3, 7)
    -- print("bonus: " .. flr(bouns_timer/30), 20, 20, 5)
end

function draw_postday()
    cls(0)

    all_particles = {}
    letters = {}

    print("deliveries: " .. (deliveries[1] + deliveries[2]), 20, 40, 7)
    print("customers: " .. deliveries[1], 20, 48, 7)
    print("non-customers: " .. deliveries[2], 20, 48 + 8, 7)

    draw_skip()
end

function draw_day()
    cls(0)
    print("\^w\^t" .. days[day], hcenter("\^w\^t" .. days[day]), vcenter( "\^w\^t" .. days[day]), 7)
    draw_skip()
end

function draw_skip()
    print("🅾️ to skip", 80, 2)
end

function is_colliding(a, b)
    if b.x >= a.x + 8
        or b.x + 8 <= a.x
        or b.y >= a.y + 8
        or b.y + 8 <= a.y then
        return false
    else
        return true
    end
end

function is_colliding_pro(a, b)
    if a.x < b.x + b.w and
        a.x + a.w > b.x and
        a.y < b.y + b.h and
        a.y + a.h > b.y then
        return true
    else
        return false
    end
end

function draw_gui()
    rectfill(0, 121, 128, 128, 0)
    print("score:" .. score, 3, 123, 7)
    print("hp", 103, 123, 7)



    for i = 1, p1.max_health, 1 do
        pset(110 + (2 * i), 123, 5)
        pset(110 + (2 * i), 124, 5)
        pset(110 + (2 * i), 125, 5)
        pset(110 + (2 * i), 126, 5)
        pset(110 + (2 * i), 127, 5)
    end

    for i = 1, p1.life, 1 do
        pset(110 + (2 * i), 123, 7)
        pset(110 + (2 * i), 124, 7)
        pset(110 + (2 * i), 125, 7)
        pset(110 + (2 * i), 126, 7)
        pset(110 + (2 * i), 127, 7)
    end


    -- for k, v in pairs(customers) do
    --  pal(6, v)
    --  spr(16, 38 + (8 * k), 122)
    --  pal()
    --end

    print(days[day], hcenter(days[day]), 123, 7)



    --rectfill(48, 124, 50, 126, customers[1])
    -- rectfill(52, 124, 54, 126, customers[2])
    --rectfill(56, 124, 58, 126, customers[3])
end

function start_level()
    clock.is_running = true
end

function advance_day()
    day += 1
    if day == 8 then day = 1 end
    intro_t = 30 * 6
    day_t = 30 * 3
    post_t = 30 * 6
    p1 = init_player()
    deliveries_left = deliveries_needed
    g_state = gamestates.day_title
    init_wind()
end

function change_state(new_state)
    offset = 0
    g_state = new_state
end

-- function set_customers()
--     shuffle(cols)
--     customers = { cols[1], cols[2] }
--     non_customers = { cols[3], cols[4] }
-- end

function angle_lerp(angle1, angle2, t)
    angle1 = angle1 % 1
    angle2 = angle2 % 1

    if abs(angle1 - angle2) > 0.5 then
        if angle1 > angle2 then
            angle2 += 1
        else
            angle1 += 1
        end
    end

    return ((1 - t) * angle1 + t * angle2) % 1
end

function print_debug(str)
    printh("debug: " .. str, 'debug.txt')
end

function hcenter(s)
    -- screen center minus the
    -- string length times the
    -- pixels in a char's width,
    -- cut in half
    return 64 - #s * 2
end

function vcenter(s)
    -- screen center minus the
    -- string height in pixels,
    -- cut in half
    return 61
end

function shuffle(t)
    -- do a fisher-yates shuffle
    for i = #t, 1, -1 do
        local j = flr(rnd(i)) + 1
        t[i], t[j] = t[j], t[i]
    end
end

function randf_rang(l, h)
    local h = h - l
    return l + rnd(h)
end

function randi_rang(l, h)
    return flr(rnd(h)) + l
end

function randsec_rang(l, h)
    return (flr(rnd(h)) + l) * 30
end

function draw_hitbox(o)
    rect(o.x, o.y, (o.x + o.w), (o.y + o.h), 8)
end

function goto_bonus()
    p1.move_speed = 1.5
    spawner.reset()
    bouns_timer = bouns_length
    change_state(gamestates.bonus)
    spawner.running = true
end

function goto_gameover(reason)
    spawner:reset()
    --[[
        1=death
        2=missing
        3=fired
        4=3days
    ]] --
    if reason == 1 then
        end_text = endings[1]
        ending_idx = 1
    elseif reason == 2 then
        end_text = endings[2]
        ending_idx = 2
    elseif reason == 3 then
    elseif reason == 4 then
        if score >= good_score then
            end_text = endings[4]
            ending_idx = 4
        else
            end_text = endings[5]
            ending_idx = 5
        end
    end
    sfx(19)
    change_state(gamestates.gameover)
end

function draw_gameover()
    cls(7)
    spr(192, 32, 8, 8, 2)
    print("$0.25", 6, 10, 5)
    print("score: " .. score, 10, 32, 5)
    print("acc: " .. p1:get_acc().."%", 10, 38, 5)
    rect(4, 30, 124, 120, 5)
    pal(14, 0)
    spr(end_spr[ending_idx], 80, 34, 4, 4)
    pal()
    print("game over", game_over_x, 1, 0)
    print(end_text[1], 10, 40 + 5, 0)
    print(end_text[2], 10, 48 + 5, 0)
    fillp(▤)
    rectfill(10, 70, 76, 95, 0)
    rectfill(10, 100, 90, 110, 0)
    rectfill(90, 70, 110, 90, 6)
    fillp()
end

function update_gameover()
    game_over_x += 1
    if game_over_x == 130 then
        game_over_x = -30
    end
end

function screen_shake()
    local fade = 0.95
    local offset_x = 16 - rnd(32)
    local offset_y = 16 - rnd(32)

    offset_x *= offset
    offset_y *= offset

    camera(offset_x, offset_y)

    offset *= fade
    if offset < 0.05 then
        offset = 0
    end
end

function dist(a, b)
    return abs(a.x - b.x) + abs(a.y - b.y)
end
