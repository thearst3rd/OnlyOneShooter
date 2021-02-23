-- The phase where it charges at you

local opponentPhaseCharge = {}
opponentPhaseCharge.__index = opponentPhaseCharge


local isCharging = true
local chargeUpTime = 1.5
local chargeTime = 1.5

local CHARGE_SPEED = 500


opponentPhaseCharge.SPAWN_Y = 150
opponentPhaseCharge.DEFAULT_BULLET_COOLDOWN = 1


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseCharge.new()
	local self = classes.opponentBase.new(opponentPhaseCharge)
	return self
end

function opponentPhaseCharge:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end


	if isCharging then
		chargeUpTime = chargeUpTime - dt
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	else
		self.x = self.x + math.cos(self.angle) * CHARGE_SPEED * dt
		self.y = self.y + math.sin(self.angle) * CHARGE_SPEED * dt
		chargeTime = chargeTime - dt
	end

	if self.x - self.radius < 0 then self.x = self.radius end
	if self.x + self.radius >= ARENA_WIDTH then self.x = ARENA_WIDTH - self.radius - 1 end
	if self.y - self.radius < 0 then self.y = self.radius end
	if self.y + self.radius >= ARENA_HEIGHT then self.x = ARENA_HEIGHT - self.radius - 1 end

	if chargeUpTime <= 0 then
		isCharging = false
		chargeUpTime = 1.5
	elseif chargeTime <= 0 then
		isCharging = true
		chargeTime = 1.5
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
