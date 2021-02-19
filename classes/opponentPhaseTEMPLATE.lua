-- The template opponent phase

local opponentPhaseTEMPLATE = {}
opponentPhaseTEMPLATE.__index = opponentPhaseTEMPLATE


-- Uncomment and override any of these if needed
--opponentPhaseTEMPLATE.STUN_LENGTH = 0.3
--opponentPhaseTEMPLATE.IFRAME_LENGTH = 0.7
--opponentPhaseTEMPLATE.RADIUS = 25
--opponentPhaseTEMPLATE.SPAWN_X = (ARENA_WIDTH / 2)
--opponentPhaseTEMPLATE.SPAWN_Y = (ARENA_HEIGHT / 2)
--opponentPhaseTEMPLATE.SPAWN_ANG = (math.pi / 2)
--opponentPhaseTEMPLATE.NUM_LIVES = 3
--opponentPhaseTEMPLATE.DEFAULT_BULLET_COOLDOWN = nil 	-- nil means don't use default shooting method
--opponentPhaseTEMPLATE.DEFAULT_BULLET_SPEED = nil 	-- nil means use default speed


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseTEMPLATE.new()
	local self = classes.opponentBase.new(opponentPhaseTEMPLATE)
	return self
end

function opponentPhaseTEMPLATE:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- ... rest of method here ...
end

function opponentPhaseTEMPLATE:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseTEMPLATE:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseTEMPLATE = opponentPhaseTEMPLATE
