-- A bullet template class

local bulletTEMPLATE = {}
bulletTEMPLATE.__index = bulletTEMPLATE


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletTEMPLATE.new(x, y, angle, friendly, speed)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletTEMPLATE)
	return self
end

function bulletTEMPLATE:update(dt)
	-- Call superclass method
	classes.bullet.update(self, dt)

	-- ... rest of method here ...
end

function bulletTEMPLATE:draw()
	-- Optional - draw default opponent
	classes.bullet.draw(self)
end

function bulletTEMPLATE:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end
end

classes.bulletTEMPLATE = bulletTEMPLATE
