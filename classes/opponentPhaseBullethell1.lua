-- The template opponent phase

local opponentPhaseBullethell1 = {}
opponentPhaseBullethell1.__index = opponentPhaseBullethell1

local ORBIT_START_ANG = -math.pi / 2
local ORBIT_ANG_SPEED = 1.0 	-- How many radians per second should the opponent advance in orbit?
local ORBIT_RADIUS_X = 400
local ORBIT_RADIUS_Y = 250

local ORBIT_FOCAL_X = ARENA_WIDTH / 2
local ORBIT_FOCAL_Y = ARENA_HEIGHT / 2


opponentPhaseBullethell1.RADIUS = 30
opponentPhaseBullethell1.SPAWN_X = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(ORBIT_START_ANG)
opponentPhaseBullethell1.SPAWN_Y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(2 * ORBIT_START_ANG)
opponentPhaseBullethell1.NUM_LIVES = 12


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseBullethell1.new()
	local self = classes.opponentBase.new(opponentPhaseBullethell1)

	self.currentCooldown = 0
	self.bulletCooldownTime = 0.1
	self.shotAng = "horizontal"
	self.numShotsToSwitch = 3
	self.orbitAng = ORBIT_START_ANG

	self.NUM_BULLETS = 6

	return self
end

function opponentPhaseBullethell1:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

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

	--Move
	self.orbitAng = self.orbitAng + ORBIT_ANG_SPEED * dt
	self.x = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(self.orbitAng)
	self.y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(2 * self.orbitAng)
	self.angle = self.orbitAng + math.pi

end

function opponentPhaseBullethell1:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseBullethell1:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseBullethell1 = opponentPhaseBullethell1
