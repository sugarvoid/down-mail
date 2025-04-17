local function __spawn_mailbox(resident_id)
    if mailbox_num < #residents then
        local lane = get_available_lane()
        spawn_mbox(lane, mailbox_num)
        mailbox_num = mid(0, mailbox_num + 1, #residents)
    end
end

local danger_zone_left = hitbox.new({ x = 3, y = 0 }, 10, 120)
local danger_zone_right = hitbox.new({ x = 115, y = 0 }, 10, 120)

lanes = {
    { 16,  false },
    { 25,  false },
    { 34,  false },
    { 43,  false },
    { 52,  false },
    { 61,  false },
    { 70,  false },
    { 79,  false },
    { 88,  false },
    { 97,  false },
    { 106, false },
}

spawner = {
    start = function(self)
        --print_debug("today is " .. days[day])
        self.rock_1 = randsec_rang(3, 10)
        self.rock_2 = randsec_rang(3, 10)
        self.mail_box = 60
        self.mail_box_2 = randsec_rang(3, 10)
        self.dog = randsec_rang(5, 10)
        self.running = true
        self.tmr_branch_left = 0
        self.tmr_branch_right = 0
    end,
    stop = function (self)
        self.running = false
    end,

    --spawn_obj =function(self, kind, lane)
    --  if kind == 1 then spawn_mbox(lane)
    -- elseif kind == 2 then spawn_rock(lane)
    --else spawn_dog() end
    --end,

    update = function(self)
        if self.running then
            if g_state == gamestates.game then
                self.rock_1 -= 1
                self.mail_box -= 1
                self.mail_box_2 -= 1

                if day >= 2 then
                    self.rock_2 -= 1
                    self.dog -= 1
                end

                if self.rock_1 <= 0 then
                    local lane = get_available_lane()
                    spawn_rock(lane)
                    self.rock_1 = randsec_rang(3, 10)
                end

                if self.rock_2 <= 0 then
                    local lane = get_available_lane()
                    spawn_rock(lane)
                    self.rock_2 = randsec_rang(3, 10)
                end

                if self.mail_box <= 0 then
                    __spawn_mailbox(mailbox_num)
                    self.mail_box = randsec_rang(1, 4)
                end

                if self.mail_box_2 <= 0 then
                    __spawn_mailbox(mailbox_num)
                    self.mail_box_2 = randsec_rang(2, 5)
                end

                if self.dog <= 0 then
                    self.dog = randsec_rang(9, 20)
                    if #dogs == 0 then
                        spawn_dog()
                    end
                end

               


                if is_colliding(p1.hitbox, danger_zone_left) then
                    self.tmr_branch_left += 1
                    if self.tmr_branch_left >= 20 then
                        --logger.debug("Spawn tree branch left")
                        spawn_branch("left")
                        self.tmr_branch_left = 0
                    end
                else
                    self.tmr_branch_left = 0
                end

                if is_colliding(p1.hitbox, danger_zone_right) then
                    self.tmr_branch_right += 1
                    print_debug(self.tmr_branch_right)
                    if self.tmr_branch_right >= 20 then
                        spawn_branch("right")
                        self.tmr_branch_right = 0
                    end
                else
                    self.tmr_branch_right = 0
                end
            end
        end
    end,
    reset = function()
        sfx(-2, 3) -- in case dog enter sound is playing
        clear_objs()
        for k, v in ipairs(lanes) do
            lanes[k][2] = false
        end
    end,
}

function object_count()
    return (
        #mailboxes +
        #rocks +
        #twisters +
        #dogs
    )
end

function get_available_lane()
    local _idx
    repeat
        _idx = flr(rnd(#lanes)) + 1
    until lanes[_idx][2] == false
    return _idx
end

function update_lane(lane, occupied)
    lanes[lane][2] = occupied
end

function clear_objs()
    mailboxes = {}
    rocks = {}
    twisters = {}
    dogs = {}
    --objects.front = {}
    --objects.back = {}
    all_particles = {}
end
