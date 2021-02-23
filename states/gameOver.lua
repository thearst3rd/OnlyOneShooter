-- Game over state

local gameOver = {}
gameOver.__index = gameOver


--------------------
-- MAIN CALLBACKS --
--------------------

function gameOver.new(index)
	local self = setmetatable({}, gameOver)

	self.continueIndex = index or 0

	return self
end

function gameOver:update(dt)
	-- TODO: write this function
end

function gameOver:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.large)
	love.graphics.printf("GAME OVER", 0, 200, ARENA_WIDTH, "center")
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("Press 'C' to continue, 'R' to restart", 0, 500, ARENA_WIDTH, "center")
end


---------------------
-- OTHER CALLBACKS --
---------------------

function gameOver:keypressed(key, scancode, isrepeat)
	if key == "c" then
		state = states.game.new(self.continueIndex)
	elseif key == "r" then
		state = states.game.new()
	elseif key == "escape" then
		state = states.menu.new()
	end
end

states.gameOver = gameOver
