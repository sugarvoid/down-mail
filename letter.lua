
Letter = {}
Letter.__index = Letter


all_letters = {}
--local image = love.graphics.newImage("wind.png")
local img_open = love.graphics.newQuad(40, 8, 8, 8, SPRITESHEET)

local ani_frames = {
    love.graphics.newQuad(0, 16, 8, 8, SPRITESHEET),
    love.graphics.newQuad(8, 16, 8, 8, SPRITESHEET),
    love.graphics.newQuad(16, 16, 8, 8, SPRITESHEET),
    love.graphics.newQuad(24, 16, 8, 8, SPRITESHEET)
}

local img_1 = love.graphics.newQuad(0, 16, 8, 8, SPRITESHEET)
local img_2 = love.graphics.newQuad(8, 16, 8, 8, SPRITESHEET)
local img_3 = love.graphics.newQuad(16, 16, 8, 8, SPRITESHEET)
local img_4 = love.graphics.newQuad(24, 16, 8, 8, SPRITESHEET)

function Letter:new(x, y, dir)
	local _mailbox = setmetatable({}, Letter)
	_mailbox.x = x 
	_mailbox.y = y 
    _mailbox.dir = dir
    _mailbox.img_inx = 1
    _mailbox.frame_time = 0.2
    _mailbox.elapsed_time = 0
    _mailbox.facing_dir = 1
    _mailbox.img = ani_frames[1]
	--self.sy = x
    _mailbox.moving_dir = 2 * dir
	
	return _mailbox

end



function Letter:draw()
	love.graphics.draw(SPRITESHEET, ani_frames[self.img_inx], self.x+4, self.y+1, 0, self.facing_dir, 1, 4, 1) 
end

function Letter:update(dt)
    self.x = self.x + self.moving_dir
	--self.y = self.y + 1
 	--self.ey = self.y + self.length --* dt
	--if self.y == 128+3 then
	--	self:reset()
	--end
    self.elapsed_time = self.elapsed_time  + dt    -- Add delta time to elapsed time

    -- Check if it's time to advance to the next frame
    if self.elapsed_time >= self.frame_time then
        self.elapsed_time = 0               -- Reset elapsed time
        self.img_inx = self.img_inx  + 1   -- Move to the next frame

        -- Loop back to the first frame if we've reached the end
        if self.img_inx  > #ani_frames then
            self.img_inx  = 1
        end
    end
end

function Letter:reset()
	self.y = 0
	self.ey = self.y + 3
	self.x = math.random(1, 127)
end
