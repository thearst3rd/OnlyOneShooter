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
		nextState = states.game.new()
	end
end

function menu:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("ONLY ONE SHOOTER", 0, 100, ARENA_WIDTH, "center")
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("press space to go to game\npress alt+enter to toggle fullscreen", 0, 500, ARENA_WIDTH, "center")
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
