-- The "normal" opponent phase where it acts like a space invader

local opponentPhaseNormal = {}
opponentPhaseNormal.__index = opponentPhaseNormal


opponentPhaseNormal.NUM_LIVES = 4
opponentPhaseNormal.SPAWN_Y = 100
opponentPhaseNormal.DEFAULT_BULLET_COOLDOWN = 1

--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseNormal.new()
	local self = classes.opponentBase.new(opponentPhaseNormal)

	-- Constants
	self.ADVANCE_DISTANCE = 125

	-- Movement variables
	self.advance = false
	self.xspeed = 200
	self.yspeed = 200
	self.advanceDist = 0

	return self
end

function opponentPhaseNormal:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Update opponent values
	self.advanceDist = self.advanceDist + self.yspeed * dt

	-- Update opponent movement
	if not self.advance then
		self.x = self.x + self.xspeed * dt
	else
		self.y = self.y + self.yspeed * dt
	end

	if self.x < self.radius then
		self.x = self.radius
		self.xspeed = math.abs(self.xspeed)
		if self.y < ARENA_HEIGHT - self.ADVANCE_DISTANCE - self.radius - 1 then
			self.advance = true
		end
	elseif self.x >= ARENA_WIDTH - self.radius then
		self.x = ARENA_WIDTH - self.radius - 1
		self.xspeed = -math.abs(self.xspeed)
		if self.y < ARENA_HEIGHT - self.ADVANCE_DISTANCE - self.radius - 1 then
			self.advance = true
		end
	end

	if self.advanceDist >= self.ADVANCE_DISTANCE then
		self.advance = false
		self.advanceDist = 0
	end
end

function opponentPhaseNormal:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseNormal:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseNormal = opponentPhaseNormal
