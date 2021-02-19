-- The template opponent phase

local opponentPhaseOrbit = {}
opponentPhaseOrbit.__index = opponentPhaseOrbit


local ORBIT_START_ANG = -math.pi / 2
local ORBIT_ANG_SPEED = 1.2 	-- How many radians per second should the opponent advance in orbit?
local ORBIT_RADIUS_X = 400
local ORBIT_RADIUS_Y = 250

local ORBIT_FOCAL_X = ARENA_WIDTH / 2
local ORBIT_FOCAL_Y = ARENA_HEIGHT / 2


opponentPhaseOrbit.SPAWN_X = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(ORBIT_START_ANG)
opponentPhaseOrbit.SPAWN_Y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(ORBIT_START_ANG)
opponentPhaseOrbit.DEFAULT_BULLET_COOLDOWN = 0.4


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseOrbit.new()
	local self = classes.opponentBase.new(opponentPhaseOrbit)

	self.orbitAng = ORBIT_START_ANG

	return self
end

function opponentPhaseOrbit:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Update position
	self.orbitAng = self.orbitAng + ORBIT_ANG_SPEED * dt
	self.x = ORBIT_FOCAL_X + ORBIT_RADIUS_X * math.cos(self.orbitAng)
	self.y = ORBIT_FOCAL_Y + ORBIT_RADIUS_Y * math.sin(self.orbitAng)
	self.angle = self.orbitAng + math.pi
end

function opponentPhaseOrbit:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseOrbit:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseOrbit = opponentPhaseOrbit
