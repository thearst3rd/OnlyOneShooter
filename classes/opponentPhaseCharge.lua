-- The phase where it charges at you

local opponentPhaseCharge = {}
opponentPhaseCharge.__index = opponentPhaseCharge


opponentPhaseCharge.SPAWN_Y = 150
opponentPhaseCharge.DEFAULT_BULLET_COOLDOWN = 0.15
opponentPhaseCharge.NUM_LIVES = 4


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseCharge.new()
	local self = classes.opponentBase.new(opponentPhaseCharge)

	self.chargeState = "preparation"
	self.useDefaultShooting = false
	self.preparationTime = 1
	self.chargeTime = 1
	self.chaseTime = 1
	self.MAX_TURN_SPEED = 3
	self.CHARGE_SPEED = 800
	self.CHASE_SPEED = 400
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	return self
end

function opponentPhaseCharge:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end


	if self.chargeState == "charging" then
		self.x = self.x + math.cos(self.angle) * self.CHARGE_SPEED * dt
		self.y = self.y + math.sin(self.angle) * self.CHARGE_SPEED * dt
		self.chargeTime = self.chargeTime - dt
	elseif self.chargeState == "chasing" then
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
		self.chaseTime = self.chaseTime - dt
	else --if self.chargeState == "preparation" then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
		self.preparationTime = self.preparationTime - dt
	end

	if self.x - self.radius < 0 then self.x = self.radius end
	if self.x + self.radius >= ARENA_WIDTH then self.x = ARENA_WIDTH - self.radius - 1 end
	if self.y - self.radius < 0 then self.y = self.radius end
	if self.y + self.radius >= ARENA_HEIGHT then self.y = ARENA_HEIGHT - self.radius - 1 end

	if self.preparationTime <= 0 then
		self.chargeState = "charging"
		self.useDefaultShooting = true
		self.bulletSpeed = 350 + self.CHARGE_SPEED
		self.preparationTime = 1
	elseif self.chargeTime <= 0 then
		self.chargeState = "chasing"
		self.bulletSpeed = 350 + self.CHASE_SPEED
		self.chargeTime = 1
	elseif self.chaseTime <= 0 then
		self.chargeState = "preparation"
		self.useDefaultShooting = false
		self.chaseTime = 1
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
