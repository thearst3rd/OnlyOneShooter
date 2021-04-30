-- The spin opponent phase

local opponentPhaseSpin = {}
opponentPhaseSpin.__index = opponentPhaseSpin

opponentPhaseSpin.DEFAULT_BULLET_COOLDOWN = 0.3
opponentPhaseSpin.DEFAULT_BULLET_SPEED = 750
opponentPhaseSpin.NUM_LIVES = 4

--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseSpin.new()
	local self = classes.opponentBase.new(opponentPhaseSpin)

	-- Randomize direction to one of 8 directions
	local r = love.math.random()
	if r <= 0.5 then
		self.xspeed = 400
		self.yspeed = 200
	else
		self.xspeed = 200
		self.yspeed = 400
	end
	if r % 0.5 <= 0.25 then self.xspeed = -self.xspeed end
	if r % 0.25 <= 0.125 then self.yspeed = -self.yspeed end

	self.angspeed = 2.4 * math.pi

	return self
end

function opponentPhaseSpin:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	self.x = self.x + self.xspeed * dt
	if self.x < self.radius then
		self.x = self.radius
		self.xspeed = math.abs(self.xspeed)
	elseif self.x >= ARENA_WIDTH - self.radius then
		self.x = ARENA_WIDTH - self.radius - 1
		self.xspeed = -math.abs(self.xspeed)
	end

	self.y = self.y + self.yspeed * dt
	if self.y < self.radius then
		self.y = self.radius
		self.yspeed = math.abs(self.yspeed)
	elseif self.y >= ARENA_HEIGHT - self.radius then
		self.y = ARENA_HEIGHT - self.radius - 1
		self.yspeed = -math.abs(self.yspeed)
	end

	self.angle = self.angle + self.angspeed * dt
end

function opponentPhaseSpin:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseSpin:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseSpin = opponentPhaseSpin
