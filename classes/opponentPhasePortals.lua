-- Now you're thinking with portals

local opponentPhasePortals = {}
opponentPhasePortals.__index = opponentPhasePortals


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhasePortals.new()
	local self = classes.opponentBase.new(opponentPhasePortals)

	self.CHASE_SPEED = 200							--Is there a danger in having the same variable names across different phases/files?
	self.SHOT_COOLDOWN = 1
	self.SHOTS_BETWEEN_PORTALS = 5
	self.shotCooldown = self.SHOT_COOLDOWN
	self.shotNumber = 0
	self.bulletSpeed = 250

	return self
end

function opponentPhasePortals:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end

	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	self.x = self.x + math.cos(self.angle) * self.CHASE_SPEED * dt
	self.y = self.y + math.sin(self.angle) * self.CHASE_SPEED * dt

	self.shotCooldown = self.shotCooldown - dt
	if self.shotCooldown <= 0 and self.shotNumber % self.SHOTS_BETWEEN_PORTALS == 0 then
		local bluePortal = classes.bulletBluePortal.new(self.x, self.y, self.angle, false, self.bulletSpeed)
		table.insert(state.bullets, bluePortal)
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		self.shotNumber = self.shotNumber + 1
	elseif self.shotCooldown <= 0 and self.shotNumber % self.SHOTS_BETWEEN_PORTALS == 1 then
		local orangePortal = classes.bulletOrangePortal.new(self.x, self.y, self.angle, false, self.bulletSpeed)
		table.insert(state.bullets, orangePortal)
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		self.shotNumber = self.shotNumber + 1
	elseif self.shotCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, self.angle, false, self.bulletSpeed))
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		self.shotNumber = self.shotNumber + 1
	end
end

function opponentPhasePortals:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhasePortals:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhasePortals = opponentPhasePortals
