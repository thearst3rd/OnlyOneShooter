-- The second bullethell phase, introduces ~bouncy bullets~

local opponentPhaseBullethell2 = {}
opponentPhaseBullethell2.__index = opponentPhaseBullethell2

local ORBIT_START_ANG = -math.pi / 2
local ORBIT_ANG_SPEED = 0.8 	-- How many radians per second should the opponent advance in orbit?
local ORBIT_RADIUS_X = 400
local ORBIT_RADIUS_Y = 250

local ORBIT_FOCAL_X = ARENA_WIDTH / 2
local ORBIT_FOCAL_Y = ARENA_HEIGHT / 2

local MAX_TURN_SPEED = 1
local BOUNCY_BULLET_SPREAD = 0.3

local BOUNCY_BULLET_COOLDOWN_TIME = 0.6


opponentPhaseBullethell2.RADIUS = 35
opponentPhaseBullethell2.SPAWN_X = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(ORBIT_START_ANG)
opponentPhaseBullethell2.SPAWN_Y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * -0.7 * math.sin(3 * ORBIT_START_ANG)
opponentPhaseBullethell2.NUM_LIVES = 12
opponentPhaseBullethell2.INTRO_TEXT = "Boing! 2: Electric Boogaloo"


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseBullethell2.new()
	local self = classes.opponentBase.new(opponentPhaseBullethell2)

	self.orbitAng = ORBIT_START_ANG

	self.bouncyCurrentCooldown = 0.5

	if state.player then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	end

	return self
end

function opponentPhaseBullethell2:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Shoot bouncy bullets
	self.bouncyCurrentCooldown = self.bouncyCurrentCooldown - dt
	if self.bouncyCurrentCooldown < 0 then
		local bulletAng = self.angle - BOUNCY_BULLET_SPREAD / 2
		for i = 1, 3 do
			table.insert(state.bullets, classes.bulletBouncy.new(self.x, self.y, bulletAng, false, self.bulletSpeed))
			bulletAng = bulletAng + (BOUNCY_BULLET_SPREAD / 2)
		end
		self.bouncyCurrentCooldown = self.bouncyCurrentCooldown + BOUNCY_BULLET_COOLDOWN_TIME
		sounds.bulletFiringOpponentBouncy:stop()
		sounds.bulletFiringOpponentBouncy:play()
	end

	--Move
	self.orbitAng = self.orbitAng + ORBIT_ANG_SPEED * dt
	self.x = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(self.orbitAng)
	self.y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * -0.7 * math.sin(3 * self.orbitAng)

	-- Aim at player
	if state.player then
		local targetAng = math.atan2(state.player.y - self.y, state.player.x - self.x)
		local diff = normalizeAngle(targetAng - self.angle)

		if diff > MAX_TURN_SPEED * dt then
			self.angle = self.angle + MAX_TURN_SPEED * dt
		elseif diff < -MAX_TURN_SPEED * dt then
			self.angle = self.angle - MAX_TURN_SPEED * dt
		else
			self.angle = targetAng
		end
	end
end

function opponentPhaseBullethell2:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseBullethell2:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseBullethell2 = opponentPhaseBullethell2
