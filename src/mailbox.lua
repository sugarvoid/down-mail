mailbox = {}
mailbox.__index = mailbox
mailboxes = {}

function spawn_mbox(lane, id)
    local _mb = setmetatable({}, mailbox)
    _mb.r_id = id
    _mb.is_customer = residents[id][1]
    _mb.m_type = nil --[[
        1=customer
        2=non_customers
        3=bonus
        4=rainbow
    ]]

    if _mb.is_customer then
        _mb.b_col = 12
    else
        _mb.b_col = 2
    end

    _mb.m_type = 1



    _mb.speed = rnd({0.7, 0.9, 1.3})

	-- if rand <= 0.50 then -- 50% customer
        
    --     _mb.b_col = 12
    --     --mb_tracker[1] += 1
	-- elseif rand <= 0.90 then -- 40% non_customer
	-- 	_mb.m_type = 2
    --     _mb.b_col = 2
    --     --mb_tracker[2] += 1
	-- else                 -- 10% bonus
	-- 	_mb.m_type = 3
    --     _mb.b_col = 11
    --     _mb.speed = 1.6
	-- end

    _mb.lane = lane
    _mb.x = lanes[lane][1]
    _mb.y = 128
    _mb.facing_l = _mb.x > 128 / 2
    _mb.img = 21
    _mb.empty = true
    _mb.damaged = false
    --_mb.dx = 1.3
    add(mailboxes, _mb)
    update_lane(lane, true)
end

function mailbox:update()
    self.y -= self.speed

    if self.y >= 132 then
        del(mailboxes, self)
        update_lane(self.lane, false)
    end

    if self.y <= -16 then
        if self.empty and self.is_customer then
            print_debug("in update")
            self:unsubscribe("miss")
        end
        del(mailboxes, self)
        update_lane(self.lane, false)
    end

    if is_colliding(p1, self) and not self.damaged then
        self:take_damage()
    end
end

function mailbox:take_damage()
    if self.empty then
       offset = 0.1
        sfx(3)
        if self.empty and self.is_customer then
            self:unsubscribe("crash")
        end
        self.damaged = true
        self.img = 22
        self.speed = -2
    end
end

function mailbox:draw()
    pal(6, self.b_col)
    spr(self.img, self.x, self.y, 1, 1, self.facing_l)
    pal()
    spr(37, self.x, self.y + 8)
end

-- function mailbox:check(points)
--     if not self.empty and not self.damaged then
--         if self.m_type == 1 then
--             p1.deliveries += 1
--             --score += (10 * flr(points))
--             update_score(10 * flr(points))
--             sfx(4)
--         elseif self.m_type == 2 then
--             p1.deliveries += 1
--             update_score(10 * flr(points))
--             --score -= 10
--             sfx(4)
--         else
--             --score += (10 * flr(points) * 1.5)
--             update_score(10 * flr(points) * 1.5)
--             deliveries[3] += 1
--             sfx(21)
--         end
--     end
-- end

function mailbox:on_good_letter(_score)
    self.empty = false
    self.img = 20
    self.speed = 4
    explode(self.x, self.y, 2, 6, self.b_col, 10)
    sfx(4)

    if self.is_customer then
        update_score(10 * flr(_score))
    end
    
end


function mailbox:unsubscribe(reason)
    -- Change mailbox to a non-customer (red one)
    residents[self.r_id][1] = false
    
end

