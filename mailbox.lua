
MailBox = {}
MailBox.__index = MailBox


all_mailboxes = {}
--local image = love.graphics.newImage("wind.png")
local img_open = love.graphics.newQuad(40, 8, 8, 8, SPRITESHEET)

function MailBox:new(x, y)
	local _mailbox = setmetatable({}, MailBox)
	_mailbox.x = x 
	_mailbox.y = y 
    _mailbox.facing_dir = 1
    _mailbox.img = img_open
	--self.sy = x
	
	return _mailbox

end

function make_mailbox()
	local ran_x = math.random(1, 127)
	local ran_y = math.random(1, 127)
	local _mb = MailBox:new(ran_x, ran_y)
	table.insert(all_mailboxes, _mb)

end


function MailBox:draw()
	love.graphics.draw(SPRITESHEET, self.img, self.x+4, self.y+1, 0, self.facing_dir, 1, 4, 1) 
end

function MailBox:update(dt)
	--self.y = self.y + 1
 	--self.ey = self.y + self.length --* dt
	--if self.y == 128+3 then
	--	self:reset()
	--end
end

function MailBox:reset()
	self.y = 0
	self.ey = self.y + 3
	self.x = math.random(1, 127)
end
