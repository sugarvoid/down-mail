

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
    rock_1 = randsec_rang(3, 10),
    rock_2 = randsec_rang(3, 10),
    mail_box = randsec_rang(3, 10),
    mail_box_2 = randsec_rang(1, 2),
    demon = 30 * 10,
    ring = 30,
    ammo = 30,

    update = function(self)
        if g_state == gamestates.game then
            self.rock_1 -= 1
            self.rock_2 -= 1
            self.mail_box -= 1
            self.mail_box_2 -= 1
            self.demon -= 1
            self.ammo -= 1

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
                self.mail_box = randsec_rang(2, 4)
            end

            if self.mail_box_2 <= 0 then
                local lane = get_available_lane()
                spawn_mbox(lane)
                self.mail_box_2 = randsec_rang(2, 4)
            end

            if self.demon <= 0 then
                self.demon = randsec_rang(9, 20)
                spawn_demon()
            end

            if self.ammo <= 0 then
                self.ammo = randsec_rang(6, 12)
                spawn_package()
            end

            -- update objects
            for mb in all(mailboxes) do
                mb:update()
            end
            for r in all(rocks) do
                r:update()
            end
        elseif g_state == gamestates.bonus then
            self.ring -= 1

            if self.ring <= 0 then
                spawn_ring()
                self.ring = 60
            end

            for r in all(rings) do
                r:update()
            end
        end
    end,
    reset = function()
        mailboxes = {}
        rocks = {}
        rings = {}
        objects.front = {}
        objects.back = {}
        all_particles = {}
    end,
}


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
