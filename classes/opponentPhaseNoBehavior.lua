-- The template opponent phase

local opponentPhaseNoBehavior = {}
opponentPhaseNoBehavior.__index = opponentPhaseNoBehavior

opponentPhaseNoBehavior.NUM_LIVES = 4

--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseNoBehavior.new()
	local self = classes.opponentBase.new(opponentPhaseNoBehavior)
	return self
end

function opponentPhaseNoBehavior:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- ... rest of method here ...
end

function opponentPhaseNoBehavior:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)

	-- Draw Tutorial Message
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("WASD to move\nMouse to aim\nLeft Click to shoot", ARENA_WIDTH - 300, 100, 300, "center")
end

function opponentPhaseNoBehavior:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseNoBehavior = opponentPhaseNoBehavior
