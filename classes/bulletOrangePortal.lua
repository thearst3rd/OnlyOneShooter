-- The orange portal

local bulletOrangePortal = {}
bulletOrangePortal.__index = bulletOrangePortal


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletOrangePortal.new(x, y, angle, friendly, speed)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletOrangePortal)
	return self
end

function bulletOrangePortal:update(dt)
	-- Call superclass method
	classes.bullet.update(self, dt)

	-- ... rest of method here ...
end

function bulletOrangePortal:draw()
	love.graphics.setColor(1, 0.3647, 0)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function bulletOrangePortal:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end
end

classes.bulletOrangePortal = bulletOrangePortal
