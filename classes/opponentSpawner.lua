-- Manager class that spawns different opponent phases

local opponentSpawner = {}
opponentSpawner.__index = opponentSpawner

function opponentSpawner.new()
	local self = setmetatable({}, opponentSpawner)

	self.index = 1
	self.list =
	{
		classes.opponentPhaseNormal,
		classes.opponentPhaseNormal,
		classes.opponentPhaseNormal,
		classes.opponentPhaseRolling,
		classes.opponentPhaseRolling,
		classes.opponentPhaseNoBehavior,
		classes.opponentPhaseNoBehavior,
	}

	self.spawning = false
	self.spawningTimeRemaining = 0

	return self
end

function opponentSpawner:update(dt)
	if self.spawning then
		self.spawningTimeRemaining = self.spawningTimeRemaining - dt
		if self.spawningTimeRemaining <= 0 then
			self.spawning = false
			self.spawningTimeRemaining = 0

			if self.list[self.index] then
				state.opponent = self.list[self.index].new()
				self.index = self.index + 1
			else
				state = states.ending.new()
			end
		end
	end
end

function opponentSpawner:draw()
	if self.spawning then
		local prevWidth = love.graphics.getLineWidth()
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("line", ARENA_WIDTH / 2, ARENA_HEIGHT / 2, self.spawningTimeRemaining * 1500)

		love.graphics.setLineWidth(prevWidth)
	end

	if debug then
		if self.spawning then
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(self.spawningTimeRemaining, 10, 10)
		end
	end
end

function opponentSpawner:triggerNext(time)
	if self.spawning then return end
	self.spawning = true
	self.spawningTimeRemaining = time
end



classes.opponentSpawner = opponentSpawner
