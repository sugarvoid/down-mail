mailboxes = {}

mailbox = {}
mailbox.__index = mailbox

function spawn_mbox(lane)
    local _mb = setmetatable({}, mailbox)
    _mb.lane = lane
    _mb.x = lanes[lane][1]
    _mb.y = 128
    _mb.facing_l = _mb.x > 128 / 2
    _mb.b_col = rnd(cols)
    _mb.img = 21
    _mb.empty = true
    _mb.damaged = false
    _mb.dir = 0
    _mb.dx = 1.3
    _mb.speed = rnd({ 0.5, 0.7, 0.9 })


    
    add(mailboxes, _mb)
    update_lane(lane, true)
    reset_mb_timer()
end

function mailbox:update()
    self.y -= self.speed

    if self.y <= -16 or self.y >= 130 then
        del(mailboxes, self)
        update_lane(self.lane, false)
    end

    if is_colliding(p1, self) and not self.damaged then
        sfx(3)
        self.damaged = true
        self.img = 22
        self.speed = -2
        damaged_mb += 1
        if damaged_mb == 3 then
            end_text = endings[4]
            g_state = 2
        end
    end
end

function mailbox:draw()
    pal(6, self.b_col)
    spr(self.img, self.x, self.y, 1, 1, self.facing_l)
    pal()
    spr(37, self.x, self.y + 8)
end

-- function mailbox:in_range(x_val)
--     return x_val >= self.x - 10 and x_val <= self.x + 10
-- end

function is_customer(col)
    for v in all(customers) do
        --print_debug(v)
        if col == v then
            print_debug("yes")
            return true
        end
    end
    print_debug("no")
    return false
end

function mailbox:on_good_letter(_score)
    self.img = 20
    score += (10 * flr(_score))

    --FIXME: Not working
    if is_customer(self.b_col) then
        deliveries[1] += 1
        sfx(4)
    else
        deliveries[2] += 1
        sfx(5)
    end
    
    explode(self.x, self.y, 2, 6, self.b_col)
    self.empty = false
    self.speed = 4
    
    if deliveries_left == 0 then
        goto_bonus()
        --advance_day()
    end
end



function reset_mb_timer()
    next_mb = 70 + rnd(10)
end
