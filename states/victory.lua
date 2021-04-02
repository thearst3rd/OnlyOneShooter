-- victory object/state class

local victory = {}
victory.__index = victory


--------------------
-- MAIN CALLBACKS --
--------------------

function victory.new()
	local self = setmetatable({}, victory)

	self.timer = 0
	self.TIME_TO_MENU = 10

	return self
end

function victory:update(dt)
	self.timer = self.timer + dt
	if self.timer >= self.TIME_TO_MENU then
		nextState = states.menu.new()
	end
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
