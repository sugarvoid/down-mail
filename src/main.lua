is_debug = false

all_clocks = {
    __clocks = {},
    update = function(self)
        for c in all(self.__clocks) do
            c:update()
        end
    end,
    add = function(self, c)
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
    got_new_customer = false
    new_score = 0

    misses_gui_x = 70
    day = 1
    intro_t = 30 * 6
    day_t = 30 * 3
    post_t = 30 * 8
    spawner:reset()
    game_clock:reset()
    score = 0
    post_day_timer = 0
    offset = 0
    day_deliveries = 0
    customer_count = 10
    noncustomer_count = 5
    new_customers = 0
    unsubscribers = 0
    mailbox_num = 1
    show_results = false
    residents = {}
    setup_residents()
    init_wind()
    p1 = init_player()
    change_state(gamestates.title)
end

function _init()
    poke(0x5f5c, 255)
    hud = { tic = 0 }
    game_clock = clock.new()
    results_clock = clock.new()

    all_clocks:add(game_clock)
    all_clocks:add(results_clock)

    intro_t = 30 * 6
    day_t = 30 * 6
    post_t = 30 * 8
    gamestates = {
        title = 0,
        how_to = 1,
        day_title = 2,
        game = 3,
        gameover = 5,
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

    level_length = 20
    post_day_length = 5
    end_spr = { 64, 68, 72, 76, 140 }
    objects = { back = {}, front = {} }

    days = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }

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
        -- elseif g_state == gamestates.post_day then
        --     draw_postday()
    end

    if is_debug then
        print("mem: " .. flr(stat(0)) .. "kb", 10, 0, 8)
        print("cpu: " .. stat(1) * 100 .. "%", 10, 8, 8)
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

    if mailbox_num == #residents then
        game_clock:stop()
        spawner:stop()
        if object_count() == 0 and not show_results then
            sfx(22)
            --clear_objs()
            show_results = true
            game_clock:reset()
            game_clock:start()
            results_clock:start()
            if day_deliveries == customer_count then
                resubscribe()
            end
        end
    end


    if results_clock.seconds >= 3 and results_clock.is_running then
        results_clock:stop()
        show_results = false

        results_clock:reset()
        --p1.move_speed = 1.5
        spawner.reset()
        advance_day()
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

    for mb in all(mailboxes) do
        mb:update()
    end
    for r in all(rocks) do
        r:update()
    end

    spawner:update()
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

    if show_results then
        draw_results()
    end
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
    print("⬅️➡️ move", 35, 45, 7)
    print("⬆️⬇️ adjust chute", 35, 55, 7)
    print(" 🅾️  throw", 35, 65, 7)
    print("❎ back", 8, 120, 7)
end

function draw_results()
    -- print("deliveries:", 20, 40, 7)
    -- print(p1.deliveries, 80, 40, 7)

    if got_new_customer then
        print("customers gained: 1", 10, 48, 7)
    else
        print("customers lost: " .. unsubscribers, 10, 48, 7)
    end

    -- print("crashed:", 20, 48 + 8, 7)
    -- print(p1.damaged_mb, 80, 48 + 8, 7)
end

function draw_day()
    cls(0)
    local title = "\^w\^t" .. days[day]
    local cust = "customers: " .. customer_count

    print(title, hcenter(title), 61, 7)
    print(cust, hcenter(cust), 75, 7)
    draw_skip()
end

function draw_skip()
    print("🅾️ to skip", 80, 2)
end

function is_colliding(a, b)
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
    rectfill(10, 121, 118, 128, 0)

    hud.tic += 1
    if hud.tic >= 1 then
        if score < new_score then
            score += 1
        end
        hud.tic = 0
    end

    print("score:" .. score, 10, 123, 7)
    print("mail:" .. p1.letters, 85, 123, 7)
end

function start_level()
    game_clock:start()
end

function advance_day()
    got_new_customer = false
    customer_count = 0
    unsubscribers = 0
    for r in all(residents) do
        if r == true then
            customer_count += 1
        end
    end
    day += 1
    day_deliveries = 0
    mailbox_num = 1
    intro_t = 180
    day_t = 90
    post_t = 180

    --deliveries_total += p1.deliveries
    --missed_mb_total += p1.missed_mb
    --damaged_mb_total += p1.damaged_mb
    --p1 = init_player()

    p1.x = 54
    p1.y = 54
    p1.letters = 20

    if customer_count == 0 then
        goto_gameover(3)
    else
        g_state = gamestates.day_title
        init_wind()
    end
end

function change_state(new_state)
    offset = 0
    --shake(0)
    g_state = new_state
end

-- function shake(n)
--     offset = n
-- end

function print_debug(str)
    printh("debug: " .. str, 'debug.txt')
end

function hcenter(str)
    return 64 - print(str, 0, -1000) / 2
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

-- function draw_hitbox(o)
--     rect(o.x, o.y, (o.x + o.w), (o.y + o.h), 8)
-- end

function goto_bonus()
    p1.move_speed = 1.5
    spawner.reset()
    post_day_timer = post_day_length
    change_state(gamestates.bonus)
    spawner.running = true
end

function goto_gameover(reason)
    --spawner:reset()
    game_clock:reset()
    results_clock:reset()
    --[[
        1=death
        2=missing
        3=fired
    ]]
    --
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
    --score = mid(0, score + val, 32000)
    new_score = mid(0, score + val, 32000)
end

function setup_residents()
    for _ = 1, customer_count do
        add(residents, true)
    end
    for _ = 1, noncustomer_count do
        add(residents, false)
    end
    shuffle(residents)
    add(residents, {}) --Hacky way to handle spawning all mailboxes.
end
