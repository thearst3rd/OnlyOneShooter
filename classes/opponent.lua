-- The opponent class

local opponent = {}
opponent.__index = opponent

-- Constants
local OPPONENT_SPEED = 200
local OPPONENT_BULLET_COOLDOWN = 1
local OPPONENT_IFRAME_TIME = 0.5

function opponent.new()
	local self = setmetatable({}, opponent)

	self.radius = 25
	self.x = love.graphics.getWidth() - self.radius * 4
	self.y = self.radius * 4
	self.xspeed = 0
	self.yspeed = 0
	self.direction = false
	self.advance = false
	self.life = 3

	self.shotCooldown = 0
	self.advanceDist = 0
	self.iframes = 0

	return self
end

function opponent:update(dt)
	-- Update opponent values
	self.shotCooldown = self.shotCooldown + dt
	self.advanceDist = self.advanceDist + OPPONENT_SPEED * dt

	-- Update opponent movement
	if not self.advance then
		if self.direction then
			self.x = self.x + OPPONENT_SPEED * dt
		else
			self.x = self.x - OPPONENT_SPEED * dt
		end
	else
		self.y = self.y + OPPONENT_SPEED * dt
	end

	if self.x - self.radius <= 0 then self.direction = true end
	if self.x + self.radius >= ARENA_WIDTH then
		self.advance = true
		self.direction = false
	end

	if self.advanceDist >= 125 then
		self.advance = false
		self.advanceDist = 0
	end

	-- Shoot bullets
	if self.shotCooldown > OPPONENT_BULLET_COOLDOWN then
		table.insert(bullets, classes.bullet.new(self.x, self.y, math.pi / 2, false))
		self.shotCooldown = 0
	end

	-- Collide with bullets
	if self.iframes <= 0 then
		for i, bullet in ipairs(bullets) do
			if bullet.friendly then
				if math.sqrt((self.x - bullet.x) ^ 2 + (self.y - bullet.y) ^ 2) <= (self.radius + bullet.radius) then
					self.life = self.life - 1
					if self.life == 0 then self.markForDeletion = true end
					self.iframes = OPPONENT_IFRAME_TIME

					bullet.markForDeletion = true
					break
				end
			end
		end
	else
		self.iframes = self.iframes - dt
		if self.iframes < 0 then self.iframes = 0 end
	end
end

function opponent:draw()
	local alpha = 1
	if self.iframes ~= 0 then
		-- Do 3 flashes
		local numFlashes = 3

		-- It's timed this way so that it goes transparent the moment it gets hit, but also stops being transparent the
		-- moment that the i-frames wear off

		local unit = OPPONENT_IFRAME_TIME / (2 * numFlashes - 1)
		if (self.iframes % (2 * unit)) < unit then
			alpha = 0.4
		end
	end
	love.graphics.setColor(0.1, 0.4, 0.7, alpha)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

-- Register class
classes.opponent = opponent
