-- Now you're thinking with portals

local opponentPhasePortals = {}
opponentPhasePortals.__index = opponentPhasePortals


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhasePortals.new()
	local self = classes.opponentBase.new(opponentPhasePortals)

	self.CHASE_SPEED = 250
	self.MAX_TURN_SPEED = 2
	self.SHOT_COOLDOWN = 0.7
	self.SHOTS_BETWEEN_PORTALS = 5
	self.BORDER_OFFSET = 100
	self.shotCooldown = self.SHOT_COOLDOWN
	self.shotNumber = 0
	self.bulletSpeed = 250
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	return self
end

function opponentPhasePortals:update(dt)
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
	if self.x < self.radius + self.BORDER_OFFSET then
		self.x = self.radius + self.BORDER_OFFSET
	end
	if self.x > ARENA_WIDTH - self.radius - self.BORDER_OFFSET then
		self.x = ARENA_WIDTH - self.radius - self.BORDER_OFFSET
	end
	if self.y < self.radius + self.BORDER_OFFSET then
		self.y = self.radius + self.BORDER_OFFSET
	end
	if self.y > ARENA_HEIGHT - self.radius - self.BORDER_OFFSET then
		self.y = ARENA_HEIGHT - self.radius - self.BORDER_OFFSET
	end

	self.shotCooldown = self.shotCooldown - dt
	if self.shotCooldown <= 0 and self.shotNumber % self.SHOTS_BETWEEN_PORTALS == 0 then
		local bluePortalBullet = classes.bulletPortal.new(self.x, self.y, self.angle, false, self.bulletSpeed, "blue")
		table.insert(state.bullets, bluePortalBullet)
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		self.shotNumber = self.shotNumber + 1
	elseif self.shotCooldown <= 0 and self.shotNumber % self.SHOTS_BETWEEN_PORTALS == 2 then
		local orangePortalBullet = classes.bulletPortal.new(self.x, self.y, self.angle, false, self.bulletSpeed, "orange")
		table.insert(state.bullets, orangePortalBullet)
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		self.shotNumber = self.shotNumber + 1
	elseif self.shotCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, self.angle, false, self.bulletSpeed))
		self.shotCooldown = self.shotCooldown + self.SHOT_COOLDOWN
		self.shotNumber = self.shotNumber + 1
	end

	if self.portaled then
		self.portaled = self.portaled - dt
		if self.portaled <= 0 then self.portaled = nil end
	end
end

function opponentPhasePortals:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhasePortals:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)

	if state.bluePortal then state.bluePortal.markForDeletion = true end
	if state.orangePortal then state.orangePortal.markForDeletion = true end
	for i, bullet in ipairs(state.bullets) do
		if bullet.color then
			bullet.markForDeletion = true
			bullet.noSpawnPortal = true
		end
	end
end

classes.opponentPhasePortals = opponentPhasePortals
