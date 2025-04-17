mailbox = {}
mailbox.__index = mailbox
mailboxes = {}

function spawn_mbox(lane, id)
    local mb = setmetatable({}, mailbox)
    mb.r_id = id
    mb.is_customer = residents[id]
    if mb.is_customer then
        mb.b_col = 12
    else
        mb.b_col = 2
    end

    mb.speed = rnd({ 0.7, 0.9, 1.3 })
    mb.lane = lane
    mb.x = lanes[lane][1]
    mb.y = 128
    mb.facing_l = mb.x > 128 / 2
    mb.img = 21
    mb.empty = true
    mb.damaged = false
    mb.hitbox = hitbox.new(mb, 7, 8)
    add(mailboxes, mb)
    update_lane(lane, true)
end

function mailbox:update()
    self.y -= self.speed

    if self.y >= 132 then
        del(mailboxes, self)
        update_lane(self.lane, false)
    end

    if self.y <= -20 then
        if self.empty and self.is_customer then
            print_debug("in update")
            self:unsubscribe()
        end
        del(mailboxes, self)
        update_lane(self.lane, false)
    end

    if is_colliding(p1.hitbox, self.hitbox) and not self.damaged then
        self:take_damage()
    end
    self.hitbox:update()
end

function mailbox:take_damage()
    if self.empty then
        offset = 0.1
        sfx(3)
        if self.is_customer then
            self:unsubscribe()
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

function mailbox:on_good_letter(_score)
    self.empty = false
    self.img = 20
    self.speed = 4
    explode(self.x, self.y, 2, 6, self.b_col, 10)
    sfx(4)

    if self.is_customer then
        update_score(10 * flr(_score))
        day_deliveries += 1
    end
end

function mailbox:unsubscribe()
    -- Change mailbox to a non-customer (red one)
    residents[self.r_id] = false
    unsubscribers += 1
end

function resubscribe()
    -- Change mailbox to a customer (blue one)
    for i, value in ipairs(residents) do
        if value == false then
            got_new_customer = true
            residents[i] = true
            break
        end
    end
end
