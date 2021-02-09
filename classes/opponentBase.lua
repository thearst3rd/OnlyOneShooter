-- The opponent class

local opponentBase = {}
opponentBase.__index = opponentBase

function opponentBase.new()
	local self = setmetatable({}, opponentBase)

	-- CONSTANTS - override these if needed for opponent phases
	self.STUN_LENGTH = 0.3
	self.IFRAME_LENGTH = 0.7

	self.radius = 25
	self.x = ARENA_WIDTH / 2
	self.y = ARENA_HEIGHT / 2
	self.angle = math.pi / 2

	self.life = 3
	self.iframeTime = 0
	self.stunned = false
	self.stunTime = 0

	return self
end

function opponentBase:update(dt)
	-- Collide with bullets
	if self.stunned then
		self.stunTime = self.stunTime - dt
		if self.stunTime <= 0 then
			self.stunned = false
			self.stunTime = 0
			self.iframeTime = self.IFRAME_LENGTH
		end
	else
		self.angle = self.angle + math.pi * dt
		if self.iframeTime > 0 then
			self.iframeTime = self.iframeTime - dt
			if self.iframeTime < 0 then self.iframeTime = 0 end
		else
			for i, bullet in ipairs(state.bullets) do
				if bullet.friendly then
					if math.sqrt((self.x - bullet.x) ^ 2 + (self.y - bullet.y) ^ 2) <= (self.radius + bullet.radius) then
						self.life = self.life - 1
						if self.life == 0 then self.markForDeletion = true end
						self.stunned = true
						self.stunTime = self.STUN_LENGTH

						bullet.markForDeletion = true
						break
					end
				end
			end
		end
	end
end

-- Main body
local opponentPolygon1 =
{
	-1, -2/3,
	-0.5, -1,
	0, -2/3,
	0, 2/3,
	-0.5, 1,
	-1, 2/3,
	-1, -2/3,
}

local opponentPolygon1Tri = love.math.triangulate(opponentPolygon1)

-- Leg 1
local opponentPolygon2 =
{
	0, 0.6,
	0.6, 0.6,
	0.6, 1,
	1, 1,
	1, 0.2,
	0, 0.2,
	0, 0.6,
}

local opponentPolygon2Tri = love.math.triangulate(opponentPolygon2)

-- Leg 2, same but all Y coords inverted
local opponentPolygon3 = {}
for k, v in ipairs(opponentPolygon2) do
	if k % 2 == 0 then v = -v end
	opponentPolygon3[k] = v
end

local opponentPolygon3Tri = love.math.triangulate(opponentPolygon3)

function opponentBase:draw()
	local alpha = 1
	local fillColor = {0.1, 0.4, 0.7, 1}
	local outlineColor = {0, 0, 0, 1}
	if self.stunned then
		fillColor = {0.8, 0.2, 0.2, 0.8}
		outlineColor = {0.4, 0, 0, 0.8}
	elseif self.iframeTime ~= 0 then
		-- Do 3 flashes
		local numFlashes = 3

		-- It's timed this way so that it goes transparent the moment it gets hit, but also stops being transparent the
		-- moment that the i-frames wear off

		local unit = self.IFRAME_LENGTH / (2 * numFlashes - 1)
		if (self.iframeTime % (2 * unit)) < unit then
			fillColor[4] = 0.4
			outlineColor[4] = 0.6
		end
	end
	-- Draw the opponent polygons
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.angle)
		love.graphics.scale(self.radius)

		love.graphics.setColor(fillColor)
		for _, poly in ipairs{opponentPolygon1Tri, opponentPolygon2Tri, opponentPolygon3Tri} do
			for _, tri in ipairs(poly) do
				love.graphics.polygon("fill", tri)
			end
		end

		local width = love.graphics.getLineWidth()
		love.graphics.setLineWidth(3 / self.radius)
		love.graphics.setColor(outlineColor)
		for _, poly in ipairs{opponentPolygon1, opponentPolygon2, opponentPolygon3} do
			love.graphics.line(poly)
		end
		love.graphics.setLineWidth(width)
	love.graphics.pop()

	-- Debug opponent hitbox
	if debug then
		love.graphics.setColor(1, 0, 0)
		love.graphics.circle("line", self.x, self.y, self.radius)
	end
end

function opponentBase:onDestroy()
	-- Setup the opponent spawner to spawn the next opponent after a delay
	state.opponentSpawner:triggerNext(2.5)
end

-- Register class
classes.opponentBase = opponentBase
