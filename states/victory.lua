-- victory object/state class

local victory = {}
victory.__index = victory


--------------------
-- MAIN CALLBACKS --
--------------------

function victory.new()
	local self = setmetatable({}, victory)
	return self
end

function victory:update(dt)
	-- TODO: write this function
end

function victory:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("Thank you so much for playing my game", 0, 200, ARENA_WIDTH, "center")
end


---------------------
-- OTHER CALLBACKS --
---------------------

function victory:keypressed(key, scancode, isrepeat)
	-- Return to menu
	if key == "escape" then
		nextState = states.menu.new()
	end
end

states.victory = victory
