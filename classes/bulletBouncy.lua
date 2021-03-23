-- A bullet template class

local bulletBouncy = {}
bulletBouncy.__index = bulletBouncy


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletBouncy.new(x, y, angle, friendly, speed)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletBouncy)

	self.bouncesLeft = 1

	return self
end

function bulletBouncy:update(dt)
	-- Bounce off walls
	if self.bouncesLeft > 0 then
		if self.x < self.radius then
			self.x = self.radius
			self.xspeed = math.abs(self.xspeed)
			self.bouncesLeft = self.bouncesLeft - 1
		end
		if self.x > ARENA_WIDTH - self.radius then
			self.x = ARENA_WIDTH - self.radius
			self.xspeed = -math.abs(self.xspeed)
			self.bouncesLeft = self.bouncesLeft - 1
		end
		if self.y < self.radius then
			self.y = self.radius
			self.yspeed = math.abs(self.yspeed)
			self.bouncesLeft = self.bouncesLeft - 1
		end
		if self.y > ARENA_HEIGHT - self.radius then
			self.y = ARENA_HEIGHT - self.radius
			self.yspeed = -math.abs(self.yspeed)
			self.bouncesLeft = self.bouncesLeft - 1
		end
	end

	-- Call superclass method
	classes.bullet.update(self, dt)
end

function bulletBouncy:draw()
	love.graphics.setColor(0.65, 0.2, 0.7)
	love.graphics.circle("fill", self.x, self.y, self.radius)
	if self.bouncesLeft > 0 then
		local width = love.graphics.getLineWidth()
		love.graphics.setColor(0, 0, 0)
		love.graphics.setLineWidth(3)
		love.graphics.circle("line", self.x, self.y, self.radius)
		love.graphics.setLineWidth(width)
	end
end

function bulletBouncy:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end
end

classes.bulletBouncy = bulletBouncy
