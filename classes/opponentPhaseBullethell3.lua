-- How good is your movement?

local opponentPhaseBullethell3 = {}
opponentPhaseBullethell3.__index = opponentPhaseBullethell3


local ORBIT_START_ANG = -math.pi / 2
local ORBIT_ANG_SPEED = 1.2 	-- How many radians per second should the opponent advance in orbit?
local ORBIT_RADIUS_X = 400
local ORBIT_RADIUS_Y = 250

local MAX_TURN_SPEED = 10

local ORBIT_FOCAL_X = ARENA_WIDTH / 2
local ORBIT_FOCAL_Y = ARENA_HEIGHT / 2

opponentPhaseBullethell3.RADIUS = 40
opponentPhaseBullethell3.SPAWN_X = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(ORBIT_START_ANG)
opponentPhaseBullethell3.SPAWN_Y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(2 * ORBIT_START_ANG)
opponentPhaseBullethell3.NUM_LIVES = 12


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseBullethell3.new()
	local self = classes.opponentBase.new(opponentPhaseBullethell3)

	self.BULLET_COOLDOWN_TIME = 1

	self.orbitAng = ORBIT_START_ANG
	if state.player then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	end
	self.shotState = "focus"

	self.currentCooldown = 0
	self.numBullets = 3

	return self
end

function opponentPhaseBullethell3:update(dt)
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
	if self.currentCooldown <= 0 then
		if self.shotState == "focus" then
			for i = -2, 2 do
				local ang = self.angle + (i * 0.1)
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, false, self.bulletSpeed))
			end
			self.currentCooldown = self.currentCooldown + self.BULLET_COOLDOWN_TIME
			self.shotState = "corner"
		elseif self.shotState == "corner" then
			for i = -15, -5 do
				local ang = self.angle + (i * 0.1)
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, false, self.bulletSpeed))
			end
			for i = 5, 15 do
				local ang = self.angle + (i * 0.1)
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, false, self.bulletSpeed))
			end
			self.currentCooldown = self.currentCooldown + self.BULLET_COOLDOWN_TIME
			self.shotState = "spread"
		else --if self.shotState == "spread" then
			for i = -5, 5 do
				local ang = self.angle + (i * 0.2)
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, false, self.bulletSpeed))
			end
			self.currentCooldown = self.currentCooldown + self.BULLET_COOLDOWN_TIME
			self.shotState = "focus"
		end
		sounds.bulletFiringOpponent:stop()
		sounds.bulletFiringOpponent:play()

		if self.life <= math.ceil(opponentPhaseBullethell3.NUM_LIVES / 2) then
			table.insert(state.bullets, classes.bulletBouncy.new(self.x, self.y, self.angle + math.pi / 2, false, self.bulletSpeed))
			table.insert(state.bullets, classes.bulletBouncy.new(self.x, self.y, self.angle - math.pi / 2, false, self.bulletSpeed))
			table.insert(state.bullets, classes.bulletBouncy.new(self.x, self.y, self.angle - math.pi, false, self.bulletSpeed))
			sounds.bulletFiringOpponentBouncy:stop()
			sounds.bulletFiringOpponentBouncy:play()
		end
	end

	--Move
	self.orbitAng = self.orbitAng + ORBIT_ANG_SPEED * dt
	self.x = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(self.orbitAng)
	self.y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(2 * self.orbitAng)
end

function opponentPhaseBullethell3:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseBullethell3:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseBullethell3 = opponentPhaseBullethell3
