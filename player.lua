Player = Object:extend()

function Player:new(x, y)
  self.x = x or 0
  self.y = y or 0
  self.w = 8
  self.h = 8
  self.img = love.graphics.newQuad(8, 0, 8, 8, SPRITESHEET)
  self.chute_img = love.graphics.newQuad(56, 0, 8, 8, SPRITESHEET)
  self.chute_open = love.graphics.newQuad(56, 0, 8, 8, SPRITESHEET)
  self.chute_closed = love.graphics.newQuad(64, 8, 8, 8, SPRITESHEET)
  self.facing_dir = 1

  self.is_chute_open = true
end

function Player:draw()
    
    if is_on_screen(self, {x=0,y=0,w=128,h=128}) then
      love.graphics.draw(SPRITESHEET, self.img, self.x+4, self.y+1, 0, self.facing_dir, 1, 4, 1) --, 0, self.facing_dir, self.scale_y, self.origin.x, self.origin.y) 
      love.graphics.draw(SPRITESHEET, self.chute_img, self.x, self.y - 8)
    end

    
    love.graphics.rectangle("line", self.x, self.y, 8, 8)

    --love.graphics.rectangle("line", 140, 50, 8, 8)
end

function Player:update(dt)

  print(is_on_screen(self, {x=0,y=0,w=128,h=128}))
  if self.is_chute_open then 
      self.y = self.y - (1)
    else 
      self.y = self.y + (2)
    end
end