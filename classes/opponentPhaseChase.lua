-- Unga Bunga

local opponentPhaseChase = {}
opponentPhaseChase.__index = opponentPhaseChase


opponentPhaseChase.SPAWN_Y = 150
opponentPhaseChase.DEFAULT_BULLET_COOLDOWN = 0.5
opponentPhaseChase.DEFAULT_BULLET_SPEED = 1000


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseChase.new()
	local self = classes.opponentBase.new(opponentPhaseChase)

	self.CHASE_SPEED = 400

	return self
end

function opponentPhaseChase:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	self.x = self.x + math.cos(self.angle) * self.CHASE_SPEED * dt
	self.y = self.y + math.sin(self.angle) * self.CHASE_SPEED * dt
end

function opponentPhaseChase:draw()
	classes.opponentBase.draw(self)
end

function opponentPhaseChase:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseChase = opponentPhaseChase
