-- The opponent class

local opponentBase = {}
opponentBase.__index = opponentBase

function opponentBase.new(implClass)
	local self = setmetatable({}, implClass)

	-- CONSTANTS - override these if needed for opponent phases
	self.STUN_LENGTH = implClass.STUN_LENGTH or 0.3
	self.IFRAME_LENGTH = implClass.IFRAME_LENGTH or 0.7

	self.radius = implClass.RADIUS or  25
	self.x = implClass.SPAWN_X or (ARENA_WIDTH / 2)
	self.y = implClass.SPAWN_Y or (ARENA_HEIGHT / 2)
	self.angle = implClass.SPAWN_ANG or (math.pi / 2)

	self.life = implClass.NUM_LIVES or 6
	self.iframeTime = 0
	self.stunned = false
	self.stunTime = 0

	self.intangible = false 	-- Set to true if it shouldn't collide with player

	-- Default shooting method: if implClass.DEFAULT_BULLET_COOLDOWN is defined then shoot bullets by default
	if implClass.DEFAULT_BULLET_COOLDOWN and implClass.DEFAULT_BULLET_COOLDOWN >= 0 then
		self.useDefaultShooting = true
		self.bulletCooldownTime = implClass.DEFAULT_BULLET_COOLDOWN
		self.bulletSpeed = implClass.DEFAULT_BULLET_SPEED
		self.currentCooldown = self.bulletCooldownTime
	end

	return self
end

function opponentBase:update(dt)
	if self.stunned then
		self.stunTime = self.stunTime - dt
		if self.stunTime <= 0 then
			self.stunned = false
			self.stunTime = 0
			self.iframeTime = self.IFRAME_LENGTH
		end
	else
		-- Collide with bullets
		if self.iframeTime > 0 then
			self.iframeTime = self.iframeTime - dt
			if self.iframeTime < 0 then self.iframeTime = 0 end
		else
			for i, bullet in ipairs(state.bullets) do
				if bullet.friendly then
					if calcDist(self.x, self.y, bullet.x, bullet.y) <= (self.radius + bullet.radius) then
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

		-- Shoot bullets
		if self.useDefaultShooting then
			self.currentCooldown = self.currentCooldown - dt
			if self.currentCooldown <= 0 then
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, self.angle, false, self.bulletSpeed))
				self.currentCooldown = self.currentCooldown + self.bulletCooldownTime
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

function opponentBase:draw(alphaOverride, fillColorOverride)
	local fillColor = {0.1, 0.4, 0.7, 1}
	local outlineColor = {0, 0, 0, 1}
	-- Override fill color if need be
	if fillColorOverride then
		fillColor[1] = fillColorOverride[1]
		fillColor[2] = fillColorOverride[2]
		fillColor[3] = fillColorOverride[3]
	end
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
	-- Override alpha if need be
	if alphaOverride then
		fillColor[4] = alphaOverride
		outlineColor[4] = alphaOverride
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

	-- Return alpha value (to let other things blink along)
	return fillColor[4]
end

function opponentBase:onDestroy()
	-- Setup the opponent spawner to spawn the next opponent after a delay (only if player is alive)
	if state.player and not state.player.markForDeletion then
		state.opponentSpawner:triggerNext(2.5)
	end

	for i, bullet in ipairs(state.bullets) do
		bullet.markForDeletion = true
	end
end

-- Register class
classes.opponentBase = opponentBase
