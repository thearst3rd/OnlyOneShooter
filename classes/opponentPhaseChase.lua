-- Unga Bunga

local opponentPhaseChase = {}
opponentPhaseChase.__index = opponentPhaseChase


opponentPhaseChase.SPAWN_Y = 150
opponentPhaseChase.DEFAULT_BULLET_COOLDOWN = 0.5
opponentPhaseChase.DEFAULT_BULLET_SPEED = 1000
opponentPhaseChase.INTRO_TEXT = "Hot on your six"


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseChase.new()
	local self = classes.opponentBase.new(opponentPhaseChase)

	self.CHASE_SPEED = 400
	self.MAX_TURN_SPEED = 2
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	return self
end

function opponentPhaseChase:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end

	local newAngle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	local diff = normalizeAngle(newAngle - self.angle)
	if diff > self.MAX_TURN_SPEED * dt then
		self.angle = self.angle + self.MAX_TURN_SPEED * dt
	elseif diff < -self.MAX_TURN_SPEED * dt then
		self.angle = self.angle - self.MAX_TURN_SPEED * dt
	else
		self.angle = newAngle
	end
	self.angle = normalizeAngle(self.angle)
	self.x = self.x + math.cos(self.angle) * self.CHASE_SPEED * dt
	self.y = self.y + math.sin(self.angle) * self.CHASE_SPEED * dt

	-- Collide with walls
	if self.x < self.radius then
		self.x = self.radius
	end
	if self.x > ARENA_WIDTH - self.radius then
		self.x = ARENA_WIDTH - self.radius
	end
	if self.y < self.radius then
		self.y = self.radius
	end
	if self.y > ARENA_HEIGHT - self.radius then
		self.y = ARENA_HEIGHT - self.radius
	end
end

function opponentPhaseChase:draw()
	classes.opponentBase.draw(self)
end

function opponentPhaseChase:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseChase = opponentPhaseChase
