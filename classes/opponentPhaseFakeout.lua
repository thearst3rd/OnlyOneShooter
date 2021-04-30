-- Large cinematic with a wuss boss that dies in one shot

local opponentPhaseFakeout = {}
opponentPhaseFakeout.__index = opponentPhaseFakeout


opponentPhaseFakeout.RADIUS = 75
opponentPhaseFakeout.NUM_LIVES = 1


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseFakeout.new()
	local self = classes.opponentBase.new(opponentPhaseFakeout)

	self.APPROACH_SPEED = 100
	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)

	self.deathEpic = true

	return self
end

function opponentPhaseFakeout:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if not state.player then return end

	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	self.x = self.x + math.cos(self.angle) * self.APPROACH_SPEED * dt
	self.y = self.y + math.sin(self.angle) * self.APPROACH_SPEED * dt
end

function opponentPhaseFakeout:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseFakeout:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
	musics.musicNormal:stop()
end

classes.opponentPhaseFakeout = opponentPhaseFakeout
