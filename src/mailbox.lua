mailbox = {}
mailbox.__index = mailbox
mailboxes = {}

mb_tracker = {
    --[[
        1=customers
        2=non_customers
    ]] --
    0,
    0
}


function spawn_mbox(lane)
    local _mb = setmetatable({}, mailbox)
    _mb.m_type = nil --[[
        1=customer
        2=non_customers
        3=bonus
        4=rainbow
    ]]

    local rand = rnd()

    _mb.speed = rnd({0.7, 0.9, 1.3})

	if rand <= 0.50 then -- 50% chance for customer
        _mb.m_type = 1
        _mb.b_col = 12
        mb_tracker[1] += 1
	elseif rand <= 0.90 then -- 40% chance for non_customer
		_mb.m_type = 2
        _mb.b_col = 6
        mb_tracker[2] += 1
	else                 -- 10% chance for bonus
		_mb.m_type = 3
        _mb.b_col = 10
        _mb.speed = 1.6
	end

    _mb.lane = lane
    _mb.x = lanes[lane][1]
    _mb.y = 128
    _mb.facing_l = _mb.x > 128 / 2
    --_mb.b_col = rnd(cols)
    _mb.img = 21
    _mb.empty = true
    _mb.damaged = false
    --_mb.dir = 0
    _mb.dx = 1.3
    add(mailboxes, _mb)
    update_lane(lane, true)
end

function mailbox:update()
    self.y -= self.speed

    if self.y <= -16 or self.y >= 132 then
        del(mailboxes, self)
        update_lane(self.lane, false)
    end

    if is_colliding(p1, self) and not self.damaged then
        self:take_damage()
    end
end

function mailbox:take_damage()
    offset = 0.1
    sfx(3)
    self.damaged = true
    self.img = 22
    self.speed = -2
    damaged_mb += 1
    if damaged_mb == 3 then
        end_text = endings[3]
        ending_idx = 3
        change_state(gamestates.gameover)
    end
end

function mailbox:draw()
    pal(6, self.b_col)
    spr(self.img, self.x, self.y, 1, 1, self.facing_l)
    pal()
    spr(37, self.x, self.y + 8)
end

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

function mailbox:check(points)
    if not self.empty and not self.damaged then
        if self.m_type == 1 then
            deliveries[1] += 1
            score += (10 * flr(points))
            sfx(4)
        elseif self.m_type == 2 then
            score += 5
            deliveries[2] += 1
            sfx(5)
        else
            score += (10 * flr(points) * 1.5)
            deliveries[3] += 1
            sfx(21)
        end
        -- deliveries_left -= 1
        -- if deliveries_left == 0 then
        --     goto_bonus_tmr = 60
        --     sfx(2)
        --     clear_objs()
        --     spawner.running = false
        -- end
    end
end

function mailbox:on_good_letter(_score)
    self.empty = false
    self:check(_score)
    self.img = 20
    explode(self.x, self.y, 2, 6, self.b_col, 10)
    self.speed = 4
end


