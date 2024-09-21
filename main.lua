Object = require "lib.classic"
class = require 'lib.middleclass'
love.graphics.setDefaultFilter("nearest", "nearest")


require("player")
--local push = require("lib.push")
anim8 = require("lib.anim8")
flux = require("lib.flux")



SPRITESHEET = love.graphics.newImage("full_sheet.png")

slots = { 2, 20, 38, 56, 74, 92, 110 }


all_windlines = {}



--WINDOW_W, WINDOW_H = love.window.getDesktopDimensions()
--WINDOW_W, WINDOW_H = WINDOW_W * 0.8, WINDOW_H * 0.8

local player = Player(30,30)

print(player.x)

function love.load()
    math.randomseed(os.time())
    font = love.graphics.newFont("monogram.ttf", 32)
    font:setFilter("nearest")
    love.graphics.setFont(font)
    
    -- if your code was optimized for fullHD:
	window = {translateX = 0, translateY = 0, scale = 4, width = 128, height = 128}
	width, height = love.graphics.getDimensions()
	love.window.setMode (width, height, {resizable=true, borderless=false})
	resize (width, height) -- update new translation and scale
end

function love.update(dt)
    flux.update(dt)
    if love.keyboard.isDown('d') then
        player.x = player.x + 1
        player.facing_dir = 1
    end
    if love.keyboard.isDown('a') then
        player.x = player.x - 1
        player.facing_dir = -1
    end
    if love.keyboard.isDown('w') then
        player.is_chute_open = true
        player.chute_img = player.chute_open
    end
    if love.keyboard.isDown('s') then
        player.is_chute_open = false
        player.chute_img = player.chute_closed
    end
    player:update(dt)
    -- mouse position with applied translate and scale:
	local mx = math.floor ((love.mouse.getX()-window.translateX)/window.scale+0.5)
	local my = math.floor ((love.mouse.getY()-window.translateY)/window.scale+0.5)
	-- your code here, use mx and my as mouse X and Y positions
	--print(mx, my)
end



function love.draw()
    -- first translate, then scale
	love.graphics.translate (window.translateX, window.translateY)
	love.graphics.scale (window.scale)
	-- your graphics code here, optimized for fullHD
	love.graphics.rectangle('line', 0, 0, 128, 128)
	love.graphics.rectangle("line", player.x, player.y, 8, 8)
    
    --love.graphics.push("all")
   -- love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
    --love.graphics.rectangle("fill", 0, 0, 128, 128)
    --love.graphics.pop()


    --start of draw_play()
    player:draw()

end

function resize (w, h) -- update new translation and scale:
	local w1, h1 = window.width, window.height -- target rendering resolution
	local scale = math.min (w/w1, h/h1)
	window.translateX, window.translateY, window.scale = (w-w1*scale)/2, (h-h1*scale)/2, scale
end

function love.resize (w, h)
	resize (w, h) -- update new translation and scale
end

function love.keypressed(key, scancode, isrepeat)

    --print(isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    if key == "left" then -- move right
        print("left")
    elseif key == "right" then
        print("right")
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

---Check if an object is on screen
---@param obj table
---@param rect table with screen data {x=0,y=0,w=0,h=0}
function is_on_screen(obj, rect)
    if ((obj.x >= rect.x + rect.w) or
           (obj.x + obj.w <= rect.x) or
           (obj.y >= rect.y + rect.h) or
           (obj.y + obj.h <= rect.y)) then
              return false 
    else return true
    end
end