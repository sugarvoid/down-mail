Player = Object:extend()

function Player:new(x, y)
  self.x = x or 0
  self.y = y or 0
  self.img = love.graphics.newQuad(8, 0, 8, 8, SPRITESHEET)
end

function Player:draw()
    
    love.graphics.draw(SPRITESHEET, self.img, self.x, self.y) --, 0, self.facing_dir, self.scale_y, self.origin.x, self.origin.y) 
    love.graphics.rectangle("line", self.x, self.y, 8, 8)
end

function Player:update(dt)
  
end