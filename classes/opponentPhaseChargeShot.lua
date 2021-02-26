-- Imma firin ma lasor

local opponentPhaseChargeShot = {}
opponentPhaseChargeShot.__index = opponentPhaseChargeShot


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseChargeShot.new()
	local self = classes.opponentBase.new(opponentPhaseChargeShot)

	self.CHARGE_TIME = 3
	self.shot_cooldown = self.CHARGE_TIME
	self.bulletSpeed = 1000

	return self
end

function opponentPhaseChargeShot:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end

	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	self.shot_cooldown = self.shot_cooldown - dt
	if self.shot_cooldown <= 0 then
		local big_bullet = classes.bullet.new(self.x, self.y, self.angle, false, self.bulletSpeed)
		big_bullet.radius = 100
		table.insert(state.bullets, big_bullet)
		self.shot_cooldown = self.shot_cooldown + self.CHARGE_TIME
	end
end

function opponentPhaseChargeShot:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseChargeShot:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseChargeShot = opponentPhaseChargeShot
