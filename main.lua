Object = require "lib.classic"
class = require 'lib.middleclass'
love.graphics.setDefaultFilter("nearest", "nearest")


require("player")
local push = require("lib.push")
anim8 = require("lib.anim8")
flux = require("lib.flux")



SPRITESHEET = love.graphics.newImage("full_sheet.png")

slots = { 2, 20, 38, 56, 74, 92, 110 }



WINDOW_W, WINDOW_H = love.window.getDesktopDimensions()
WINDOW_W, WINDOW_H = WINDOW_W * 0.8, WINDOW_H * 0.8

local player = Player(30,30)

print(player.x)

function love.load()
    math.randomseed(os.time())
    font = love.graphics.newFont("monogram.ttf", 32)
    font:setFilter("nearest")
    love.graphics.setFont(font)
    push:setupScreen(128, 128, 128 * 4, 128 * 4, { fullscreen = false, vsync = false, resizable = true })
end

function love.update(dt)
    flux.update(dt)
    local x, y = love.mouse.getPosition() -- get the position of the mouse
    print(x, y) -- draw the custom mouse image
end

function love.draw()
    push:start()
    
    love.graphics.push("all")
    love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
    love.graphics.rectangle("fill", 0, 0, 128, 128)
    love.graphics.pop()


    --start of draw_play()
    player:draw()


    push:finish()

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    if key == "z" then 

    end
    if key == "x" then 

    end
    if key == "space" then 
        do_action()
    end
end

function do_action()
    print("action")
end



function start_game()
end

function table.for_each(_list)
    local i = 0
    return function()
        i = i + 1; return _list[i]
    end
end

function table.remove_item(_table, _item)
    for i, v in ipairs(_table) do
        if v == _item then
            _table[i] = _table[#_table]
            _table[#_table] = nil
            return
        end
    end
end

function draw_debug()
    love.graphics.print("player slot " .. "add", 4, 2)
    love.graphics.print("human slot " .. "add", 4, 22)
    love.graphics.print("future slot " .. "add", 4, 44)
    love.graphics.print("p looking left: " .. "add", 4, 66)
end

function goto_gameover(reason)
    -- 0 = bad lick
    -- 1 = bad move
    -- 2 = game won
    print("game over")
end




function draw_title()

end

function draw_play()

end

function draw_gameover()

end
