-- Q U A C K

local duck = {}
duck.__index = duck


--------------------
-- MAIN CALLBACKS --
--------------------

function duck.new(orbitAng, opponentX, opponentY)
	local self = setmetatable({}, duck)

	self.radius = 25
	self.orbitSpeed = 1
	self.orbitRadius = 100
	self.hp = 2

	self.orbitAng = orbitAng
	self.angle = normalizeAngle(love.math.random() * 2 * math.pi)
	self.angVelocity = love.math.random()
	if self.angVelocity < 0.5 then self.angVelocity = self.angVelocity - 1 end

	self.x = opponentX + self.orbitRadius * math.cos(self.orbitAng)
	self.y = opponentY + self.orbitRadius * math.sin(self.orbitAng)

	return self
end

function duck:update(dt)
	self.orbitAng = normalizeAngle(self.orbitAng + self.orbitSpeed * dt)
	self.x = state.opponent.x + self.orbitRadius * math.cos(self.orbitAng)
	self.y = state.opponent.y + self.orbitRadius * math.sin(self.orbitAng)
	self.angle = normalizeAngle(self.angle + self.angVelocity * dt)

	-- Collide with bullets
	for _, bullet in ipairs(state.bullets) do
		if bullet.friendly then
			if calcDist(self.x, self.y, bullet.x, bullet.y) <= (self.radius + bullet.radius) then
				self.hp = self.hp - 1
				if self.hp < 1 then
					self.markForDeletion = true
				end
				bullet.markForDeletion = true
				break
			end
		end
	end
end

function duck:draw()
	local dw, dh = images.duck:getDimensions()
	local scaleFactor = 2 * self.radius / (dw > dh and dw or dh)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(images.duck, self.x, self.y, self.angle, scaleFactor, scaleFactor, dw / 2, dh / 2)
	if debug then
		--love.graphics.setColor(1, 1, 0)
		--love.graphics.circle("fill", self.x, self.y, self.radius)
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("line", self.x, self.y, self.radius)
		love.graphics.line(self.x, self.y, self.x + self.radius * math.cos(self.angle), self.y + self.radius * math.sin(self.angle))
	end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function duck:keypressed(key, scancode, isrepeat)
	-- TODO: write or delete this function
end

classes.duck = duck
