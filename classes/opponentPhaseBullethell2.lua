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


opponentPhaseBullethell2.RADIUS = 40
opponentPhaseBullethell2.SPAWN_X = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(ORBIT_START_ANG)
opponentPhaseBullethell2.SPAWN_Y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(3 * ORBIT_START_ANG)
opponentPhaseBullethell2.NUM_LIVES = 12


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseBullethell2.new()
	local self = classes.opponentBase.new(opponentPhaseBullethell2)

	self.currentCooldown = 0
	self.bulletCooldownTime = 0.1
	self.shotAng = "horizontal"
	self.numShotsToSwitch = 3
	self.orbitAng = ORBIT_START_ANG

	self.bouncyCurrentCooldown = 0
	self.bouncyBulletCooldownTime = 0.6

	self.NUM_BULLETS = 6

	if state.player then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	end

	return self
end

function opponentPhaseBullethell2:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	--[[
	--Shoot bullets
	self.currentCooldown = self.currentCooldown - dt
	if self.currentCooldown <= 0 then
		if self.shotAng == "horizontal" then
			self.baseAng = 0
		else --if self.shotAng == "vertical"
			self.baseAng = math.pi / self.NUM_BULLETS
		end
		for i = 1, self.NUM_BULLETS do
			local ang = (2 * math.pi * i / self.NUM_BULLETS) + self.baseAng
			table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, false, self.bulletSpeed))
		end
		self.currentCooldown = self.currentCooldown + self.bulletCooldownTime
		self.numShotsToSwitch = self.numShotsToSwitch - 1
		if self.numShotsToSwitch <= 0 then
			if self.shotAng == "horizontal" then
				self.shotAng = "vertical"
			else --if self.shotAng == "vertical"
				self.shotAng = "horizontal"
			end
			self.numShotsToSwitch = 3
			self.currentCooldown = 1
		end
	end
	--]]

	-- Shoot bouncy bullets
	self.bouncyCurrentCooldown = self.bouncyCurrentCooldown - dt
	if self.bouncyCurrentCooldown < 0 then
		local bulletAng = self.angle - BOUNCY_BULLET_SPREAD / 2
		for i = 1, 3 do
			table.insert(state.bullets, classes.bulletBouncy.new(self.x, self.y, bulletAng, false, self.bulletSpeed))
			bulletAng = bulletAng + (BOUNCY_BULLET_SPREAD / 2)
		end
		self.bouncyCurrentCooldown = self.bouncyCurrentCooldown + self.bouncyBulletCooldownTime
	end

	--Move
	self.orbitAng = self.orbitAng + ORBIT_ANG_SPEED * dt
	self.x = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(self.orbitAng)
	self.y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(3 * self.orbitAng)

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
