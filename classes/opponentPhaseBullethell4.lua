-- The final boss

local opponentPhaseBullethell4 = {}
opponentPhaseBullethell4.__index = opponentPhaseBullethell4


local ORBIT_START_ANG = -math.pi / 2
local ORBIT_ANG_SPEED = 0.7 --1.2 	-- How many radians per second should the opponent advance in orbit?
local ORBIT_RADIUS_X = 400
local ORBIT_RADIUS_Y = 250

local MAX_TURN_SPEED = 1

local ORBIT_FOCAL_X = ARENA_WIDTH / 2
local ORBIT_FOCAL_Y = ARENA_HEIGHT / 2

local BULLET_COOLDOWN_TIME = 0.4
local BOUNCY_BULLET_COOLDOWN_TIME = 1
local FIREWORK_COOLDOWN_TIME = 2.5

local BULLET_SPEED = 350	-- Is also bouncy bullet speed
local FIREWORK_BULLET_SPEED = 200

opponentPhaseBullethell4.RADIUS = 45
opponentPhaseBullethell4.SPAWN_X = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(ORBIT_START_ANG)
opponentPhaseBullethell4.SPAWN_Y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(5 * ORBIT_START_ANG)
opponentPhaseBullethell4.NUM_LIVES = 12


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseBullethell4.new()
	local self = classes.opponentBase.new(opponentPhaseBullethell4)

	self.orbitAng = ORBIT_START_ANG
	if state.player then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	end

	self.currentCooldown = BULLET_COOLDOWN_TIME
	self.bouncyCurrentCooldown = BOUNCY_BULLET_COOLDOWN_TIME
	self.fireworkCurrentCooldown = FIREWORK_COOLDOWN_TIME

	return self
end

function opponentPhaseBullethell4:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	--Aim
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

	--Shoot
	self.currentCooldown = self.currentCooldown - dt
	self.bouncyCurrentCooldown = self.bouncyCurrentCooldown - dt
	self.fireworkCurrentCooldown = self.fireworkCurrentCooldown - dt
	if self.currentCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, self.angle, false, BULLET_SPEED))
		self.currentCooldown = BULLET_COOLDOWN_TIME
	end
	if self.bouncyCurrentCooldown <= 0 then
		local bulletAng = self.angle - math.pi / 4
		for i = 0, 3 do
			table.insert(state.bullets, classes.bulletBouncy.new(self.x, self.y, bulletAng, false, BULLET_SPEED))
			bulletAng = bulletAng + math.pi / 2
		end
		self.bouncyCurrentCooldown = self.bouncyCurrentCooldown + BOUNCY_BULLET_COOLDOWN_TIME
	end
	if self.fireworkCurrentCooldown <= 0 then
		table.insert(state.bullets, classes.bulletFirework.new(self.x, self.y, self.angle, false, FIREWORK_BULLET_SPEED, classes.bulletFirework))
		self.fireworkCurrentCooldown = FIREWORK_COOLDOWN_TIME
	end

	--Move
	self.orbitAng = self.orbitAng + ORBIT_ANG_SPEED * dt
	self.x = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(self.orbitAng)
	self.y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(5 * self.orbitAng)
end

function opponentPhaseBullethell4:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseBullethell4:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseBullethell4 = opponentPhaseBullethell4
