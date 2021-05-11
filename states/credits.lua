-- credits state class

local credits = {}
credits.__index = credits


--------------------
-- MAIN CALLBACKS --
--------------------

function credits.new()
	local self = setmetatable({}, credits)
	return self
end

function credits:update(dt)
	-- TODO: write this function
end

function credits:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("CREDITS", 0, 100, ARENA_WIDTH, "center")
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("todo", 0, 300, ARENA_WIDTH, "center")
end


---------------------
-- OTHER CALLBACKS --
---------------------

function credits:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		self:back()
	end
end

function credits:back()
	nextState = states.menu.new()
end

states.credits = credits
