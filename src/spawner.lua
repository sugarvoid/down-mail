spawner = {
    rock_1 = randsec_rang(3, 10),
    rock_2 = randsec_rang(3, 10),
    branch = randsec_rang(3, 10),
    mail_box = 140,
    demon = 140,

    update = function(self)
        self.rock_1 -= 1
        --self.rock_2 -= 1
        self.mail_box -=  1
        self.demon -=  1
        self.branch -=  1

        if self.rock_1 <= 0 then
            spawn_rock()
            --self.rock_1 = randi_rang(3, 10)
            self.rock_1 = randsec_rang(3, 10)
            print_debug(self.rock_1)
        end

        --if self.rock_2 <= 0 then
            --spawn_rock()
            --self.rock_2 = randsec_rang(3, 10)
        --end

        if self.branch <= 0 then
            spawn_branch()
            self.branch = randsec_rang(3, 10)
        end

        if self.mail_box <= 0 then
            spawn_mbox()
            self.mail_box = randsec_rang(2, 4)
        end

        if self.demon <= 0 then
            self.demon = randsec_rang(9, 20)
            spawn_demon()
        end


        
    end
}
