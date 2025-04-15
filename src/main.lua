
is_debug = false

all_clocks = {
    __clocks ={},
    update=function(self)
        for c in all(self.__clocks) do
            c:update()
        end
    end,
    add=function(self, c)
        add(self.__clocks, c)
    end,
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
    residents = {}
    setup_residents()
    misses_gui_x = 70
    day = 1
    --deliveries = { 0, 0, 0 }
    intro_t = 30 * 6
    day_t = 30 * 3
    post_t = 30 * 8
    spawner:reset()
    game_clock:restart()
    --set_customers()
    score = 0
    init_wind()
    p1 = init_player()
    change_state(gamestates.title)
end

function _init()
    game_clock = clock.new()
    results_clock = clock.new()

    all_clocks:add(game_clock)
    all_clocks:add(results_clock)


    poke(0x5f5c, 255)
    intro_t = 30 * 6
    day_t = 30 * 6
    post_t = 30 * 8
    gamestates = {
        title = 0,
        how_to = 1,
        day_title = 2,
        game = 3,
        gameover = 5,
        post_day = 6,
    }
    g_state = nil

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

    
    map_y = 0
    game_over_x = -10
    score = 0
    post_day_timer = 0
    deliveries = { 0, 0, 0 }
    goto_postday_tmr = 0
    offset = 0
    level_length = 20
    post_day_length = 5
   -- ending = 0
    end_spr = { 64, 68, 72, 76, 140 }
    objects = { back = {}, front = {} }
    day = 1
    days = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }

    deliveries_total = 0
    missed_mb_total = 0
    damaged_mb_total = 0

    customer_count = 10
    noncustomer_count = 5
    new_customers = 0

    mailbox_num = 1


    --residents = {}
    --setup_residents()

    restart_game()
end

function _update()
    check_input()

    map_y += .2

    if flr(map_y) == 17 then
        map_y = 0
    end

    -- if test_wormhole then
    --     test_wormhole:update()
    -- end

    if g_state == gamestates.title then
    elseif g_state == gamestates.day_title then
        update_day()
    elseif g_state == gamestates.game then
        update_play()
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
    elseif g_state == gamestates.gameover then
        draw_gameover()
    elseif g_state == gamestates.post_day then
        draw_postday()
    end

    if is_debug then
        print("mem: " .. flr(stat(0)) .. "kb", 10, 0, 8)
        print("cpu: " .. stat(1) * 100 .. "%", 10, 8, 8)

        print(game_clock.seconds, 8, 0)
    end
end

function check_input()
    if btnp(🅾️) then
        if g_state == gamestates.title then
            g_state = gamestates.day_title
        elseif g_state == gamestates.day_title then
            day_t = 0
        elseif g_state == gamestates.post_day then
            --post_t = 0
            p1:throw()
        elseif g_state == gamestates.game then
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
    elseif btnp(⬇️) then
        p1:update_chute(false)
    end

    if btnp(❎) then
        if g_state == gamestates.title then
            change_state(gamestates.how_to)
        elseif g_state == gamestates.how_to then
            change_state(gamestates.title)
        elseif g_state == gamestates.day_title then
        elseif g_state == gamestates.game then
        elseif g_state == gamestates.gameover then
        end
    end
end

function update_play()

    all_clocks:update()

    if game_clock.seconds >= level_length and object_count() == 0 then
        game_clock:stop()
        goto_postday_tmr = 60
        sfx(22)
        clear_objs()
        spawner.running = false
        game_clock:restart()
        game_clock:start()
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

    spawner:update()

    if goto_postday_tmr > 0 then
        goto_postday_tmr -= 1
        if goto_postday_tmr == 0 then
            --goto_bonus()
            change_state(gamestates.post_day)
            p1.move_speed = 1.5
            spawner.reset()
            post_day_timer = post_day_length
            --change_state(gamestates.bonus)
            --spawner.running = true
        end
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

function update_postday()
    all_clocks:update()

    if game_clock.seconds >= post_day_length then
        game_clock:stop()

        mailboxes = {}
        all_particles = {}
        letters = {}
        advance_day()
    end

    p1:update()
    update_letters()
    update_particles()
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

    -- if debug then
    --     for k, v in ipairs(lanes) do
    --         if lanes[k][2] == true then
    --             circfill(lanes[k][1] + 4, 119, 2, 10)
    --         end
    --     end
    -- end
end

function draw_title()
    cls()
    sspr(64, 96, 32, 16, 36, 20, 32 * 2, 16 * 2)
    sspr(64, 112, 32, 16, 36, 20 + 22, 32 * 2, 16 * 2)
    print("🅾️ play", hcenter("🅾️ play"), 75, 7)
    print("❎ info", hcenter("❎ info"), 83, 7)
end

function draw_howto()
    cls()
    print("⬅️➡️ move", hcenter("⬅️➡️ move"), 60-8-8, 7)
    print("⬆️⬇️ adjust chute", hcenter("⬆️⬇️ adjust chute"), 60-8, 7)
    print("🅾️ throw", hcenter("🅾️ throw"), 60, 7)
    --print("❎ swap", hcenter("❎ swap"), 68, 7)
    print("❎ back", 8, 120, 7)
end

function draw_postday()
    cls(0)
    map(0, map_y)
    p1:draw()
    draw_particles()
    draw_letters()
    draw_gui()

    print("deliveries:", 20, 40, 7)
    print(p1.deliveries, 80, 40, 7)

    print("missed:", 20, 48, 7)
    print(p1.missed_mb, 80, 48, 7)

    print("crashed:", 20, 48 + 8, 7)
    print(p1.damaged_mb, 80, 48 + 8, 7)

    line(16, 70, 16 + 70, 70, 7)

end

function draw_day()
    cls(0)
    print("\^w\^t" .. days[day], hcenter("\^w\^t" .. days[day]), 61, 7)
    draw_skip()
end

function draw_skip()
    print("🅾️ to skip", 80, 2)
end


--TODO: rename. remove "pro"
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
    -- print("hp", 103, 123, 7)

    -- for i = 1, p1.max_health, 1 do
    --     pset(110 + (2 * i), 123, 5)
    --     pset(110 + (2 * i), 124, 5)
    --     pset(110 + (2 * i), 125, 5)
    --     pset(110 + (2 * i), 126, 5)
    --     pset(110 + (2 * i), 127, 5)
    -- end

    -- for i = 1, p1.life, 1 do
    --     pset(110 + (2 * i), 123, 7)
    --     pset(110 + (2 * i), 124, 7)
    --     pset(110 + (2 * i), 125, 7)
    --     pset(110 + (2 * i), 126, 7)
    --     pset(110 + (2 * i), 127, 7)
    -- end

    print("mail:"  .. p1.letters, 55, 123, 7)
end

function start_level()
    game_clock:start()
end

function advance_day()
    resident_count = 0
        for r in all(residents) do
            if r[1] == true then
                resident_count = resident_count + 1
            end
        end
    day += 1
    mailbox_num=1
    intro_t = 30 * 6
    day_t = 30 * 3
    post_t = 30 * 6

    --deliveries_total += p1.deliveries
    --missed_mb_total += p1.missed_mb
    --damaged_mb_total += p1.damaged_mb
    p1 = init_player()

    g_state = gamestates.day_title
    init_wind()
end

function change_state(new_state)
    offset = 0
    --shake(0)
    g_state = new_state
end

-- function shake(n)
--     offset = n
-- end

-- function angle_lerp(angle1, angle2, t)
--     angle1 = angle1 % 1
--     angle2 = angle2 % 1

--     if abs(angle1 - angle2) > 0.5 then
--         if angle1 > angle2 then
--             angle2 += 1
--         else
--             angle1 += 1
--         end
--     end

--     return ((1 - t) * angle1 + t * angle2) % 1
-- end

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

function shuffle(t)
    -- do a fisher-yates shuffle
    for i = #t, 1, -1 do
        local j = flr(rnd(i)) + 1
        t[i], t[j] = t[j], t[i]
    end
end

function randf_rang(l, h)
    local _h = h - l
    return l + rnd(_h + 0.0001) -- Small offset to include h
end

function randi_rang(l, h)
    return flr(rnd(h - l + 1)) + l
end

function randsec_rang(l, h)
    return (flr(rnd(h - l + 1)) + l) * 30
end

function draw_hitbox(o)
    rect(o.x, o.y, (o.x + o.w), (o.y + o.h), 8)
end

function goto_bonus()
    p1.move_speed = 1.5
    spawner.reset()
    post_day_timer = post_day_length
    change_state(gamestates.bonus)
    spawner.running = true
end

function goto_gameover(reason)
    spawner:reset()
    game_clock:restart()
    --[[
        1=death
        2=missing
        3=fired
    ]] --
    end_text = endings[reason]
    ending_idx = reason
    sfx(19)
    change_state(gamestates.gameover)
end

function draw_gameover()
    cls(7)
    spr(192, 32, 8, 8, 2)
    print("$0.25", 6, 10, 5)
    print("score: " .. score, 10, 32, 5)
    --print("acc: " .. p1:get_acc() .. "%", 10, 38, 5)
    rect(4, 30, 124, 120, 5)
    pal(14, 0)
    spr(end_spr[ending_idx], 80, 34, 4, 4)
    pal()
    print("game over", game_over_x, 1, 0)
    print(end_text[1], 10, 46 + 5, 0)
    print(end_text[2], 10, 54 + 5, 0)
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

function update_score(val)
    score = mid(0, score + val, 32000)
end


function setup_residents()
    for _ = 1, customer_count do
        add(residents, {true})
    end
    for _ = 1, noncustomer_count do
        add(residents, {false})
    end
    shuffle(residents)
    add(residents, {}) --Hacky way to handle spawning all mailboxes. 
end