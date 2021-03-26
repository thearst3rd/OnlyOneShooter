-- The phase where it charges at you

local opponentPhaseCharge = {}
opponentPhaseCharge.__index = opponentPhaseCharge


opponentPhaseCharge.SPAWN_Y = 150
opponentPhaseCharge.DEFAULT_BULLET_COOLDOWN = 1


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseCharge.new()
	local self = classes.opponentBase.new(opponentPhaseCharge)

	self.isCharging = false
	self.chargeTime = 1
	self.chargeUpTime = 1
	self.CHARGE_SPEED = 500
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	return self
end

function opponentPhaseCharge:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end

	if self.isCharging then
		self.x = self.x + math.cos(self.angle) * self.CHARGE_SPEED * dt
		self.y = self.y + math.sin(self.angle) * self.CHARGE_SPEED * dt
		self.chargeTime = self.chargeTime - dt
	else
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
		self.chargeUpTime = self.chargeUpTime - dt
	end

	if self.x - self.radius < 0 then self.x = self.radius end
	if self.x + self.radius >= ARENA_WIDTH then self.x = ARENA_WIDTH - self.radius - 1 end
	if self.y - self.radius < 0 then self.y = self.radius end
	if self.y + self.radius >= ARENA_HEIGHT then self.y = ARENA_HEIGHT - self.radius - 1 end

	if self.chargeUpTime <= 0 then
		self.isCharging = true
		self.chargeUpTime = 1.5
	elseif self.chargeTime <= 0 then
		self.isCharging = false
		self.chargeTime = 1.5
	end
end

function opponentPhaseCharge:draw()
	classes.opponentBase.draw(self)
end

function opponentPhaseCharge:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseCharge = opponentPhaseCharge
