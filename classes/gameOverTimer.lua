-- Class that switches to 'game over' screen after a fixed time

local gameOverTimer = {}
gameOverTimer.__index = gameOverTimer


--------------------
-- MAIN CALLBACKS --
--------------------

function gameOverTimer.new(time)
	local self = setmetatable({}, gameOverTimer)

	self.timeLeft = time or 4

	return self
end

function gameOverTimer:update(dt)
	self.timeLeft = self.timeLeft - dt

	if self.timeLeft <= 0 then
		nextState = states.gameOver.new(state.opponentSpawner.index - 1)
	end
end

function gameOverTimer:draw()
	if debug then
		love.graphics.setFont(fonts.small)
		love.graphics.setColor(0, 0, 0)
		local str = string.format("%.2f", self.timeLeft)
		love.graphics.print(str, 10, 40)
	end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function gameOverTimer:keypressed(key, scancode, isrepeat)
	-- TODO: write or delete this function
end

classes.gameOverTimer = gameOverTimer
