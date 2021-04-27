-- The cake is a lie

local portal = {}
portal.__index = portal


--------------------
-- MAIN CALLBACKS --
--------------------

function portal.new(x, y, color)
	local self = setmetatable({}, portal)

	self.x = x
	self.y = y
	self.color = color
	self.collisionRadius = 15
	self.xradius = 20
	self.yradius = 32
	self.SUMMONING_SICKNESS = 1

	return self
end

function portal:update(dt)
	local otherPortal

	if self.color == "blue" then
		otherPortal = state.orangePortal
	else --if self.color == "orange" then
		otherPortal = state.bluePortal
	end

	if not otherPortal then return end

	if state.player and not state.player.portaled and calcDist(self.x, self.y, state.player.x, state.player.y) <=
			(self.collisionRadius + state.player.radius) then
		state.player.x = otherPortal.x
		state.player.y = otherPortal.y
		state.player.portaled = self.SUMMONING_SICKNESS
		sounds.teleport:stop()
		sounds.teleport:play()
	end

	if state.opponent and not state.opponent.portaled and calcDist(self.x, self.y, state.opponent.x, state.opponent.y)
			<= (self.collisionRadius + state.opponent.radius) then
		state.opponent.x = otherPortal.x
		state.opponent.y = otherPortal.y
		state.opponent.portaled = self.SUMMONING_SICKNESS
		sounds.teleport:stop()
		sounds.teleport:play()
	end

	for i, bullet in ipairs(state.bullets) do
		if not bullet.portaled and calcDist(self.x, self.y, bullet.x, bullet.y) <=
				(self.collisionRadius + bullet.radius) then
			bullet.x = otherPortal.x
			bullet.y = otherPortal.y
			bullet.portaled = self.SUMMONING_SICKNESS
			sounds.teleport:stop()
			sounds.teleport:play()
		end
	end
end

function portal:draw()
	local thickness = love.graphics.getLineWidth()
	love.graphics.setLineWidth(5)
	if self.color == "blue" then
		love.graphics.setColor(0, 0.396, 1)
	elseif self.color == "orange" then
		love.graphics.setColor(1, 0.365, 0)
	end
	love.graphics.ellipse("line", self.x, self.y, self.xradius, self.yradius)
	love.graphics.setLineWidth(thickness)
end


---------------------
-- OTHER CALLBACKS --
---------------------

function portal:onDestroy()
	if self.color == "blue" then
		if state.bluePortal == self then
			state.bluePortal = nil
		end
	elseif self.color == "orange" then
		if state.orangePortal == self then
			state.orangePortal = nil
		end
	end
end

classes.portal = portal
