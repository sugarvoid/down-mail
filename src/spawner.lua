spawner = {
    rock_1 = randsec_rang(3, 10),
    rock_2 = randsec_rang(3, 10),
    pool = randsec_rang(3, 10),
    mail_box = 140,
    demon = 140,
    ring = randsec_rang(3, 5),

    update = function(self)
        if g_state == gamestates.game then
            self.rock_1 -= 1
            self.rock_2 -= 1
            self.mail_box -= 1
            self.demon -= 1
            -- self.pool -= 1


            if self.rock_1 <= 0 then
                spawn_rock()
                --self.rock_1 = randi_rang(3, 10)
                self.rock_1 = randsec_rang(3, 10)
            end

            if self.rock_2 <= 0 then
                spawn_rock()
                self.rock_2 = randsec_rang(3, 10)
            end

            if self.pool <= 0 then
                spawn_pool()
                self.pool = randsec_rang(3, 10)
            end

            if self.mail_box <= 0 then
                spawn_mbox()
                self.mail_box = randsec_rang(2, 4)
            end

            if self.demon <= 0 then
                self.demon = randsec_rang(9, 20)
                spawn_demon()
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
                spawn_ring(2)
                self.ring = randsec_rang(2, 4)
            end
        end
    end,
    reset=function()
        mailboxes={}
        rocks={}
        objects.front={}
        objects.back={}
        all_particles={}
    end
}
