-- The template opponent phase

local opponentPhaseNoBehavior = {}
opponentPhaseNoBehavior.__index = opponentPhaseNoBehavior


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseNoBehavior.new()
	local self = classes.opponentBase.new()
	setmetatable(self, opponentPhaseNoBehavior)
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
end

function opponentPhaseNoBehavior:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseNoBehavior = opponentPhaseNoBehavior
