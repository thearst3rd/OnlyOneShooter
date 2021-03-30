-- The player class

local player = {}
player.__index = player


-- Constants
local PLAYER_MAXSPEED = 450
local PLAYER_ACCEL = 900
local PLAYER_FRICTION = 150
local PLAYER_BULLET_COOLDOWN = 0.25


function player.new()
	local self = setmetatable({}, player)

	-- Constants
	self.IFRAME_LENGTH = 1

	-- Variables
	self.x = ARENA_WIDTH / 2
	self.y = ARENA_HEIGHT * (4 / 5)
	self.radius = 15
	self.xspeed = 0
	self.yspeed = 0
	self.angle = 0
	self.timeSinceLastShot = 0
	self.health = 3
	self.iframeTime = 0
	self.markForDeletion = false

	return self
end

function player:update(dt)
	-- Update player values
	self.angle = math.atan2(relMouse.y - self.y, relMouse.x - self.x)
	self.timeSinceLastShot = self.timeSinceLastShot + dt

	-- Move player
	local accelVector = {x = 0, y = 0}

	if love.keyboard.isDown("d") then
		accelVector.x = accelVector.x + 1
	end
	if love.keyboard.isDown("a") then
		accelVector.x = accelVector.x - 1
	end
	if love.keyboard.isDown("s") then
		accelVector.y = accelVector.y + 1
	end
	if love.keyboard.isDown("w") then
		accelVector.y = accelVector.y - 1
	end

	if accelVector.x ~= 0 or accelVector.y ~= 0 then
		-- Normalize vector
		local accelMag, accelAng = toPolar(accelVector.x, accelVector.y)
		accelMag = PLAYER_ACCEL

		accelVector.x, accelVector.y = toCartesian(accelMag, accelAng)

		self.xspeed = self.xspeed + accelVector.x * dt
		self.yspeed = self.yspeed + accelVector.y * dt
	end

	local speed, ang = toPolar(self.xspeed, self.yspeed)

	if speed > PLAYER_MAXSPEED then
		speed = PLAYER_MAXSPEED
		self.xspeed = PLAYER_MAXSPEED * math.cos(ang)
		self.yspeed = PLAYER_MAXSPEED * math.sin(ang)
	end

	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	-- Apply friction
	if speed > 0 then
		speed = speed - PLAYER_FRICTION * dt
		if speed < 0 then speed = 0 end
		self.xspeed, self.yspeed = toCartesian(speed, ang)
	end

	-- Collide with walls
	if self.x < self.radius then
		self.x = self.radius
		self.xspeed = 0
	end
	if self.x > ARENA_WIDTH - self.radius then
		self.x = ARENA_WIDTH - self.radius
		self.xspeed = 0
	end
	if self.y < self.radius then
		self.y = self.radius
		self.yspeed = 0
	end
	if self.y > ARENA_HEIGHT - self.radius then
		self.y = ARENA_HEIGHT - self.radius
		self.yspeed = 0
	end

	-- Check for hurt
	if self.iframeTime > 0 then
		self.iframeTime = self.iframeTime - dt
		if self.iframeTime < 0 then self.iframeTime = 0 end
	else
		if state.opponent and not state.opponent.intangible then
			if calcDist(self.x, self.y, state.opponent.x, state.opponent.y) <= (self.radius + state.opponent.radius)
					then
				self.health = self.health - 1
				if self.health == 0 then self.markForDeletion = true end
				self.iframeTime = self.IFRAME_LENGTH
			end
		end

		for i, bullet in ipairs(state.bullets) do
			if self.iframeTime > 0 then break end
			if not bullet.friendly then
				if calcDist(self.x, self.y, bullet.x, bullet.y) <= (self.radius + bullet.radius) then
					self.health = self.health - 1
					if self.health == 0 then self.markForDeletion = true end
					self.iframeTime = self.IFRAME_LENGTH
					bullet.markForDeletion = true
				end
			end
		end

		if state.opponent and state.opponent.ducks then
			for i, duck in ipairs(state.opponent.ducks) do
				if self.iframeTime > 0 then break end
				if calcDist(self.x, self.y, duck.x, duck.y) <= (self.radius + duck.radius) then
					self.health = self.health - 1
					if self.health == 0 then self.markForDeletion = true end
					self.iframeTime = self.IFRAME_LENGTH
				end
			end
		end
	end

	if self.portaled then
		self.portaled = self.portaled - dt
		if self.portaled <= 0 then self.portaled = nil end
	end

	-- Create bullets
	if love.mouse.isDown(1) and self.timeSinceLastShot > PLAYER_BULLET_COOLDOWN then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, self.angle, true))
		self.timeSinceLastShot = 0
	end
end

local playerPolygon =
{
	30, 0,
	-20, 15,
	-12, 0,
	-20, -15,
	30, 0,
}

local playerPolygonTri = love.math.triangulate(playerPolygon)

function player:draw()
	-- Draw the player
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.angle)

		if self.iframeTime > 0.5 then
			love.graphics.setColor(0.8, 0.2, 0.2, 1-self.iframeTime)
		else
			love.graphics.setColor(1, 1, 1, 1-self.iframeTime)
		end

		for _, tri in ipairs(playerPolygonTri) do
			love.graphics.polygon("fill", tri)
		end

		local width = love.graphics.getLineWidth()
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0, 0, 0)
		love.graphics.line(playerPolygon)
		love.graphics.setLineWidth(width)
	love.graphics.pop()

	-- Debug player hitbox
	if debug then
		love.graphics.setColor(1, 0, 0)
		love.graphics.circle("line", self.x, self.y, self.radius)
	end
end

function player:onDestroy()
	state.gameOverTimer = classes.gameOverTimer.new()

	for i, bullet in ipairs(state.bullets) do
		bullet.markForDeletion = true
	end
end


-- Register class
classes.player = player
