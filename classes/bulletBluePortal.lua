-- The blue portal

local bulletBluePortal = {}
bulletBluePortal.__index = bulletBluePortal


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletBluePortal.new(x, y, angle, friendly, speed)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletBluePortal)
	return self
end

function bulletBluePortal:update(dt)
	-- Call superclass method
	classes.bullet.update(self, dt)
end

function bulletBluePortal:draw()
	love.graphics.setColor(0, 0.396, 1)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function bulletBluePortal:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end

	if self.x < -self.radius then
		--Place blue portal at x = 0, y = self.y
	elseif self.x > ARENA_WIDTH + self.radius then				--Should I redefine ARENA_HEIGHT and ARENA_WIDTH, or should I be able to retrieve them?
		--Place blue portal at x = ARENA_WIDTH, y = self.y
	elseif self.y < -self.radius then
		--Place blue portal at x = self.x, y = 0
	elseif self.y > ARENA_HEIGHT + self.radius then				--Is it alright to make this an else, or is it safer to just leave it as elseif?
		--Place blue portal at x = self.x, y = ARENA_HEIGHT
	end
end

classes.bulletBluePortal = bulletBluePortal
