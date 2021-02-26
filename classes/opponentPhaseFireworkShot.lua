-- The opponent shoots firework bullets

local opponentPhaseFireworkShot = {}
opponentPhaseFireworkShot.__index = opponentPhaseFireworkShot


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseFireworkShot.new()
	local self = classes.opponentBase.new(opponentPhaseFireworkShot)

	self.CHASE_SPEED = 200
	self.SHOT_COOLDOWN = 1
	self.shotCooldown = self.SHOT_COOLDOWN
	self.bulletSpeed = 250

	return self
end

function opponentPhaseFireworkShot:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end

	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	self.x = self.x + math.cos(self.angle) * self.CHASE_SPEED * dt
	self.y = self.y + math.sin(self.angle) * self.CHASE_SPEED * dt

	self.shotCooldown = self.shotCooldown - dt
	if self.shotCooldown <= 0 then
		local firework_bullet = classes.bulletFirework.new(self.x, self.y, self.angle, false, self.bulletSpeed)
		table.insert(state.bullets, firework_bullet)
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
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
