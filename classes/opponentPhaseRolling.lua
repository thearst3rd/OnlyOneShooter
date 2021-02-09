-- The opponent phase with normal gravity

local opponentPhaseRolling = {}
opponentPhaseRolling.__index = opponentPhaseRolling


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseRolling.new()
	local self = classes.opponentBase.new()
	setmetatable(self, opponentPhaseRolling)

	-- Constants
	self.MOVE_SPEED = 200
	self.BULLET_COOLDOWN_LENGTH = 1
	GRAVITY = 250

	-- Movement variables
	self.direction = false
	self.speed = 0

	self.shotCooldown = self.BULLET_COOLDOWN_LENGTH

	return self
end

function opponentPhaseRolling:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Update opponent values
	self.shotCooldown = self.shotCooldown - dt

	-- Update opponent movement
	if self.direction then
		self.x = self.x + self.MOVE_SPEED * dt
	else
		self.x = self.x - self.MOVE_SPEED * dt
	end

	self.y = self.y + self.speed * dt + 0.5 * GRAVITY * dt ^ 2
	self.speed = self.speed + GRAVITY * dt

	if self.x - self.radius <= 0 then self.direction = true end
	if self.x + self.radius >= ARENA_WIDTH then
		self.direction = false
	end

	if self.y + self.radius >= ARENA_HEIGHT then
		self.speed = self.speed * -0.9
	end

	-- Shoot bullets
	if self.shotCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, math.pi / 2, false))
		self.shotCooldown = self.BULLET_COOLDOWN_LENGTH
	end
end

function opponentPhaseRolling:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseRolling:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseRolling = opponentPhaseRolling
