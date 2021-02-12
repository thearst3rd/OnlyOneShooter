-- The opponent phase with normal gravity

local opponentPhaseBouncing = {}
opponentPhaseBouncing.__index = opponentPhaseBouncing

local OPPONENT_GRAVITY = 400


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseBouncing.new()
	local self = classes.opponentBase.new()
	setmetatable(self, opponentPhaseBouncing)

	-- Constants
	self.BULLET_COOLDOWN_LENGTH = 1

	-- Movement variables
	self.xspeed = 200
	self.yspeed = 0

	self.shotCooldown = self.BULLET_COOLDOWN_LENGTH

	return self
end

function opponentPhaseBouncing:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Update opponent values
	self.shotCooldown = self.shotCooldown - dt

	-- Update opponent movement
	self.x = self.x + self.xspeed * dt
	if self.x < self.radius then
		self.x = self.radius
		self.xspeed = math.abs(self.xspeed)
	elseif self.x >= ARENA_WIDTH - self.radius then
		self.x = ARENA_WIDTH - self.radius - 1
		self.xspeed = -math.abs(self.xspeed)
	end

	self.y = self.y + self.yspeed * dt
	self.yspeed = self.yspeed + OPPONENT_GRAVITY * dt

	if self.y + self.radius >= ARENA_HEIGHT then
		self.y = ARENA_HEIGHT - self.radius - 1
		self.yspeed = self.yspeed * -0.9
	end

	-- Shoot bullets
	if self.shotCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, math.pi / 2, false))
		self.shotCooldown = self.BULLET_COOLDOWN_LENGTH
	end
end

function opponentPhaseBouncing:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseBouncing:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseBouncing = opponentPhaseBouncing
