-- ending object/state class

local ending = {}
ending.__index = ending


--------------------
-- MAIN CALLBACKS --
--------------------

function ending.new()
	local self = setmetatable({}, ending)
	return self
end

function ending:update(dt)
	-- TODO: write this function
end

function ending:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Thank you so much for playing my game", 0, 200, ARENA_WIDTH, "center")
end


---------------------
-- OTHER CALLBACKS --
---------------------

function ending:keypressed(key, scancode, isrepeat)
	-- Return to menu
	if key == "escape" then
		state = states.menu.new()
	end
end

states.ending = ending
