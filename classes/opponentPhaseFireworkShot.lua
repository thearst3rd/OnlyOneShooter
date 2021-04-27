-- The opponent shoots firework bullets

local opponentPhaseFireworkShot = {}
opponentPhaseFireworkShot.__index = opponentPhaseFireworkShot


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseFireworkShot.new()
	local self = classes.opponentBase.new(opponentPhaseFireworkShot)

	self.CHASE_SPEED = 200
	self.MAX_TURN_SPEED = 1.5
	self.SHOT_COOLDOWN = 1
	self.shotCooldown = self.SHOT_COOLDOWN
	self.bulletSpeed = 250
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	return self
end

function opponentPhaseFireworkShot:update(dt)
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

	self.shotCooldown = self.shotCooldown - dt
	if self.shotCooldown <= 0 then
		local fireworkBullet = classes.bulletFirework.new(self.x, self.y, self.angle, false, self.bulletSpeed)
		table.insert(state.bullets, fireworkBullet)
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		sounds.bulletFiringOpponentFirework:stop()
		sounds.bulletFiringOpponentFirework:play()
	end
end

function opponentPhaseFireworkShot:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseFireworkShot:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseFireworkShot = opponentPhaseFireworkShot
