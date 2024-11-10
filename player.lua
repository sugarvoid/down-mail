Player = {}
Player.__index = Player


function Player:new(x, y)
  local _player = setmetatable({}, Player)
  _player.x = x or 0
  _player.y = y or 0
  _player.w = 8
  _player.h = 8
  _player.img = love.graphics.newQuad(8, 0, 8, 8, SPRITESHEET)
  _player.chute_img = love.graphics.newQuad(56, 0, 8, 8, SPRITESHEET)
  _player.chute_open = love.graphics.newQuad(56, 0, 8, 8, SPRITESHEET)
  _player.chute_closed = love.graphics.newQuad(64, 8, 8, 8, SPRITESHEET)
  _player.facing_dir = 1

  _player.is_chute_open = true
  return _player
end

function Player:draw()
  if is_on_screen(self, { x = 0, y = 0, w = 128, h = 128 }) then
    love.graphics.draw(SPRITESHEET, self.img, self.x + 4, self.y + 1, 0, self.facing_dir, 1, 4, 1)
    love.graphics.draw(SPRITESHEET, self.chute_img, self.x, self.y - 8)
  end


  love.graphics.rectangle("line", self.x, self.y, 8, 8)

  --love.graphics.rectangle("line", 140, 50, 8, 8)
end

function Player:update(dt)
  --print(is_on_screen(self, {x=0,y=0,w=128,h=128}))
  if self.is_chute_open then
    self.y = self.y - (1)
  else
    self.y = self.y + (2)
  end
end

function Player:throw_letter()
  local new_letter = Letter:new(self.x, self.y-2, self.facing_dir)
  table.insert(all_letters, new_letter)
end
