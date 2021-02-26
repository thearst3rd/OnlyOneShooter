-- A bullet that fragments into pieces

local bulletFirework = {}
bulletFirework.__index = bulletFirework


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletFirework.new(x, y, angle, friendly, speed)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletFirework)

	self.countdownTime = 1.5
	self.shake = false
	self.shakeTime = 0.5

	self.NUM_BULLETS = 6
	self.OUTGOING_BULLET_SPEED = 200

	return self
end

function bulletFirework:update(dt)
	-- Call superclass method
	classes.bullet.update(self, dt)

	self.countdownTime = self.countdownTime - dt
	if self.countdownTime <= 0 then
		self.shake = true
		self.shakeTime = self.shakeTime - dt
		if self.shakeTime <= 0 then
			for i = 1, self.NUM_BULLETS do
				local ang = 2 * math.pi * i / self.NUM_BULLETS
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, self.friendly, self.OUTGOING_BULLET_SPEED))
			end
			self.countdownTime = 1.5
			self.shake = false
			self.shakeTime = 0.5
			self.markForDeletion = true
		end
	end
end

function bulletFirework:draw()
	-- Optional - draw default opponent
	classes.bullet.draw(self)
end

function bulletFirework:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end
end

classes.bulletFirework = bulletFirework