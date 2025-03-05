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

--[[
    {type, lane}

]]--

local spawns = {
    {1, 1},
    {2, 2},
    {3, 3},
    {4, 4},
    {5, 5},
    {1, 6},
    {2, 7},
    {3, 8},
    {4, 9},
    {5, 10},
    {1, 11},
    {2, 1},
    {3, 2},
    {4, 3},
    {5, 4},
    {1, 5},
    {2, 6},
    {3, 7},
    {4, 8},
    {5, 9},
    {1, 10},
    {2, 11},
    {3, 1},
    {4, 2},
    {5, 3},
    {1, 4},
    {2, 5},
    {3, 6},
    {4, 7},
    {5, 8},
    {1, 9},
    {2, 10},
    {3, 11},
    {4, 1},
    {5, 2},
    {1, 3},
    {2, 4},
    {3, 5},
    {4, 6},
    {5, 7},
    {1, 8}
}



spawner = {
    start = function(self)
        self.rock_1 = randsec_rang(3, 10)
        self.rock_2 = randsec_rang(3, 10)
        self.mail_box = 60 --randsec_rang(3, 10)
        self.mail_box_2 = randsec_rang(3, 10)
        self.dog = randsec_rang(5, 10)
        self.running = true
    end,

    spawn_obj =function(self, kind, lane)
        if kind == 1 then spawn_mbox(lane)
        elseif kind == 2 then spawn_rock(lane)
        else spawn_dog() end
    end,

    update = function(self)
        if self.running then
            if g_state == gamestates.game then
                self.rock_1 -= 1
                self.rock_2 -= 1
                self.mail_box -= 1
                self.mail_box_2 -= 1
                self.dog -= 1

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
                    local lane = get_available_lane()
                    spawn_mbox(lane)
                    self.mail_box = randsec_rang(1, 4)
                end

                if self.mail_box_2 <= 0 then
                    local lane = get_available_lane()
                    spawn_mbox(lane)
                    self.mail_box_2 = randsec_rang(2, 5)
                end

                if self.dog <= 0 then
                    self.dog = randsec_rang(9, 20)
                    if #dogs == 0 then
                        spawn_dog()
                    end
                end

                -- update objects
                for mb in all(mailboxes) do
                    mb:update()
                end
                for r in all(rocks) do
                    r:update()
                end
            elseif g_state == gamestates.bonus then

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

function all_clear()
    return (
        #mailboxes +
        #rocks +
        #twisters +
        #dogs
    ) == 0
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
    
    objects.front = {}
    objects.back = {}
    all_particles = {}
end


