-- Game over state

local gameOver = {}
gameOver.__index = gameOver


--------------------
-- MAIN CALLBACKS --
--------------------

function gameOver.new(index)
	local self = setmetatable({}, gameOver)

	self.continueIndex = index or 1

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
	if key == "escape" then
		nextState = states.menu.new()
	end
end

function gameOver:continue()
	nextState = states.game.new(self.continueIndex)
end

function gameOver:restart()
	nextState = states.game.new()
end

states.gameOver = gameOver
