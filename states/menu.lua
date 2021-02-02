-- Menu state

local menu = {}
menu.__index = menu


--------------------
-- MAIN CALLBACKS --
--------------------

function menu.new()
	local self = setmetatable({}, menu)
	return self
end

function menu:update(dt)
	if love.keyboard.isDown("space") then
		state = states.game.new()
	end
end

function menu:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("press space to go to game lul", 10, 10)
end


---------------------
-- OTHER CALLBACKS --
---------------------

function menu:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end

states.menu = menu
