-- The "normal" opponent phase where it acts like a space invader

local opponentPhaseNormal = {}
opponentPhaseNormal.__index = opponentPhaseNormal


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseNormal.new()
	local self = classes.opponentBase.new()
	setmetatable(self, opponentPhaseNormal)

	-- Constants
	self.MOVE_SPEED = 200
	self.ADVANCE_DISTANCE = 125
	self.BULLET_COOLDOWN_LENGTH = 1

	-- Movement variables
	self.direction = false
	self.advance = false

	self.shotCooldown = self.BULLET_COOLDOWN_LENGTH
	self.advanceDist = 0

	return self
end

function opponentPhaseNormal:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Update opponent values
	self.shotCooldown = self.shotCooldown - dt
	self.advanceDist = self.advanceDist + self.MOVE_SPEED * dt

	-- Update opponent movement
	if not self.advance then
		if self.direction then
			self.x = self.x + self.MOVE_SPEED * dt
		else
			self.x = self.x - self.MOVE_SPEED * dt
		end
	else
		self.y = self.y + self.MOVE_SPEED * dt
	end

	if self.x - self.radius <= 0 then self.direction = true end
	if self.x + self.radius >= ARENA_WIDTH then
		self.advance = true
		self.direction = false
	end

	if self.advanceDist >= self.ADVANCE_DISTANCE then
		self.advance = false
		self.advanceDist = 0
	end

	-- Shoot bullets
	if self.shotCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, math.pi / 2, false))
		self.shotCooldown = self.BULLET_COOLDOWN_LENGTH
	end
end

function opponentPhaseNormal:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

classes.opponentPhaseNormal = opponentPhaseNormal
