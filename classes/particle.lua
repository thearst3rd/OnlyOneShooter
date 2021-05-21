-- Generic particle class

local particle = {}
particle.__index = particle


--------------------
-- MAIN CALLBACKS --
--------------------

function particle.new(x, y, radius, color, lifetime, speed, angle)
	local self = setmetatable({}, particle)

	self.x = x
	self.y = y

	self.radius = radius or 3
	self.color = color or {0.6, 0.6, 0.6}
	self.lifetime = self.lifetime or 0.5
	self.maxLifetime = self.lifetime
	self.lifetime = self.lifetime * (0.75 + love.math.random() * 0.5)

	self.speed = speed or (100 + (love.math.random() * 300))
	self.angle = angle or (love.math.random() * 2 * math.pi)

	return self
end

function particle:update(dt)
	self.lifetime = self.lifetime - dt
	if self.lifetime <= 0 then
		self.markForDeletion = true
	end

	local dx, dy = toCartesian(self.speed * dt, self.angle)

	self.x = self.x + dx
	self.y = self.y + dy

	self.speed = self.speed * (1 - (0.1 * dt))
end

function particle:draw()
	local alpha = math.min(1, 2 * (self.lifetime / self.maxLifetime))
	if self.color[4] then alpha = alpha * self.color[4] end
	love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end


classes.particle = particle
