-- The template opponent phase

local opponentPhaseTeleport = {}
opponentPhaseTeleport.__index = opponentPhaseTeleport


opponentPhaseTeleport.DEFAULT_BULLET_COOLDOWN = 1
opponentPhaseTeleport.INTRO_TEXT = "Nothing personnel, kid"

local TELE_TIME = 1.5 	-- animation time in seconds
local TIME_BETWEEN_TELE = 3
local ACCEL_SPEED = 600
local MAX_SPEED = 400
local FRICTION_LOSS = 50

--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseTeleport.new()
	local self = classes.opponentBase.new(opponentPhaseTeleport)

	self:initTeleport()
	self.timeToTele = 0

	self.xspeed = 0
	self.yspeed = MAX_SPEED / 2

	return self
end

function opponentPhaseTeleport:update(dt)
	-- Teleporting supercedes everything else
	if self.teleporting then
		self.teleProgress = self.teleProgress + (dt / TELE_TIME)
		if self.teleProgress >= 1 then
			self.teleporting = false
			self.timeToTele = TIME_BETWEEN_TELE
			self.intangible = false
		elseif self.teleProgress >= 0.5 and not self.halfway then
			self.x = self.teleX
			self.y = self.teleY
			self.halfway = true
			sounds.teleport:clone():play()
		end
		return
	end

	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Move and shoot
	if state.player then
		-- Apply force in direction of player
		local angToPlayer = math.atan2(state.player.y - self.y, state.player.x - self.x)

		self.xspeed = self.xspeed + ACCEL_SPEED * math.cos(angToPlayer) * dt
		self.yspeed = self.yspeed + ACCEL_SPEED * math.sin(angToPlayer) * dt

		local speed, ang = toPolar(self.xspeed, self.yspeed)

		self.angle = ang
		if speed > MAX_SPEED then speed = MAX_SPEED end

		self.xspeed, self.yspeed = toCartesian(speed, ang)
	end

	-- Update position
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	if self.x < self.radius then self.x = self.radius end
	if self.y < self.radius then self.y = self.radius end
	if self.x >= ARENA_WIDTH - self.radius then self.x = ARENA_WIDTH - self.radius end
	if self.y >= ARENA_HEIGHT - self.radius then self.y = ARENA_HEIGHT - self.radius end

	-- Apply friction
	local speed, ang = toPolar(self.xspeed, self.yspeed)
	speed = speed - FRICTION_LOSS * dt
	if speed < 0 then speed = 0 end
	self.xspeed, self.yspeed = toCartesian(speed, ang)

	self.timeToTele = self.timeToTele - dt
	if self.timeToTele <= 0 then
		self:initTeleport()
	end
end

function opponentPhaseTeleport:draw()
	-- Optional - draw default opponent
	local alphaOverride = nil
	if self.teleporting then
		alphaOverride = 2 * math.abs(0.5 - self.teleProgress)
	end
	classes.opponentBase.draw(self, alphaOverride)
end

function opponentPhaseTeleport:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end


--------------------
-- HELPER METHODS --
--------------------

function opponentPhaseTeleport:initTeleport()
	self.teleporting = true
	self.teleProgress = 0 	-- between 0 and 1, how far through the tele are we
	self.halfway = false
	self.teleX = self.radius + (love.math.random() * (ARENA_WIDTH - 2 * self.radius))
	self.teleY = self.radius + (love.math.random() * (ARENA_HEIGHT - 2 * self.radius))
	self.intangible = true

	sounds.teleport:clone():play()
end


classes.opponentPhaseTeleport = opponentPhaseTeleport
