-- The bullet class

local bullet = {}
bullet.__index = bullet

local PLAYER_BULLET_SPEED = 1000
local OPPONENT_BULLET_SPEED = 250

function bullet.new(x, y, angle, friendly)
	x = x or 100
	y = y or 100
	angle = angle or 0
	if friendly == nil then friendly = true end

	local self = setmetatable({}, bullet)

	self.x = x
	self.y = y
	self.friendly = friendly
	local speed = friendly and PLAYER_BULLET_SPEED or OPPONENT_BULLET_SPEED
	self.xspeed = math.cos(angle) * speed
	self.yspeed = math.sin(angle) * speed

	self.radius = 8

	return self
end

function bullet:update(dt)
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	if self.x < -self.radius
			or self.x > ARENA_WIDTH + self.radius
			or self.y < -self.radius
			or self.y > ARENA_HEIGHT + self.radius then
		self.markForDeletion = true
	end
end

function bullet:draw()
	love.graphics.setColor(0.7, 0.1, 0.1)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

-- Register class
classes.bullet = bullet
