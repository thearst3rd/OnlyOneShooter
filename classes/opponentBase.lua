-- The opponent class

local opponentBase = {}
opponentBase.__index = opponentBase

function opponentBase.new()
	local self = setmetatable({}, opponentBase)

	-- CONSTANTS - override these if needed for opponent phases
	self.STUN_LENGTH = 0.3
	self.IFRAME_LENGTH = 0.7

	self.radius = 25
	self.x = ARENA_WIDTH / 2
	self.y = ARENA_HEIGHT / 2

	self.life = 3
	self.iframeTime = 0
	self.stunned = false
	self.stunTime = 0

	return self
end

function opponentBase:update(dt)
	-- Collide with bullets
	if self.stunned then
		self.stunTime = self.stunTime - dt
		if self.stunTime <= 0 then
			self.stunned = false
			self.stunTime = 0
			self.iframeTime = self.IFRAME_LENGTH
		end
	elseif self.iframeTime > 0 then
		self.iframeTime = self.iframeTime - dt
		if self.iframeTime < 0 then self.iframeTime = 0 end
	else
		for i, bullet in ipairs(state.bullets) do
			if bullet.friendly then
				if math.sqrt((self.x - bullet.x) ^ 2 + (self.y - bullet.y) ^ 2) <= (self.radius + bullet.radius) then
					self.life = self.life - 1
					if self.life == 0 then self.markForDeletion = true end
					self.stunned = true
					self.stunTime = self.STUN_LENGTH

					bullet.markForDeletion = true
					break
				end
			end
		end
	end
end

function opponentBase:draw()
	local alpha = 1
	local color = {0.1, 0.4, 0.7, 1}
	if self.stunned then
		color = {0.8, 0.2, 0.2, 0.8}
	elseif self.iframeTime ~= 0 then
		-- Do 3 flashes
		local numFlashes = 3

		-- It's timed this way so that it goes transparent the moment it gets hit, but also stops being transparent the
		-- moment that the i-frames wear off

		local unit = self.IFRAME_LENGTH / (2 * numFlashes - 1)
		if (self.iframeTime % (2 * unit)) < unit then
			color[4] = 0.4
		end
	end
	love.graphics.setColor(color)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

-- Register class
classes.opponentBase = opponentBase
