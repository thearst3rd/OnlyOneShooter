-- Imma firin ma lasor

local opponentPhaseChargeShot = {}
opponentPhaseChargeShot.__index = opponentPhaseChargeShot

opponentPhaseChargeShot.INTRO_TEXT = "Ready... Aim..."


local AIM_TIME = 2
local CHARGE_TIME = 0.6
local TOTAL_TIME = AIM_TIME + CHARGE_TIME


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseChargeShot.new()
	local self = classes.opponentBase.new(opponentPhaseChargeShot)

	self.timer = AIM_TIME / 2
	self.bulletSpeed = 1000
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	return self
end

function opponentPhaseChargeShot:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	if not state.player then return end

	self.timer = self.timer + dt
	if self.timer <= AIM_TIME then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	elseif self.timer > TOTAL_TIME then
		local bigBullet = classes.bullet.new(self.x, self.y, self.angle, false, self.bulletSpeed)
		bigBullet.radius = 100
		table.insert(state.bullets, bigBullet)
		self.timer = self.timer - TOTAL_TIME
		sounds.bulletFiringOpponentLarge:stop()
		sounds.bulletFiringOpponentLarge:play()
	end
end

function opponentPhaseChargeShot:draw()
	-- Optional - draw default opponent
	if self.timer > AIM_TIME then
		local chargeLerp = (self.timer - AIM_TIME) / CHARGE_TIME
		local prevLineWidth = love.graphics.getLineWidth()
		love.graphics.setLineWidth(4)
		love.graphics.setColor(0, 0, 0, math.min(chargeLerp * 2, 1))
		love.graphics.circle("line", self.x, self.y, (1 - chargeLerp) * 300)
		love.graphics.setLineWidth(prevLineWidth)
	end
	classes.opponentBase.draw(self)
end

function opponentPhaseChargeShot:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseChargeShot = opponentPhaseChargeShot
