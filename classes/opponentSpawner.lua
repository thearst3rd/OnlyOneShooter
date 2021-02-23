-- Manager class that spawns different opponent phases

local opponentSpawner = {}
opponentSpawner.__index = opponentSpawner

function opponentSpawner.new()
	local self = setmetatable({}, opponentSpawner)

	self.index = 1
	self.list =
	{
		classes.opponentPhaseNormal,
		classes.opponentPhaseBouncing,
		classes.opponentPhaseNoBehavior,
		classes.opponentPhaseCharge,
		classes.opponentPhaseChase,
		classes.opponentPhaseSpin,
		classes.opponentPhaseOrbit,
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
				state = states.victory.new()
			end
		end
	end
end

function opponentSpawner:draw()
	if self.spawning then
		local next = self.list[self.index]
		if next then
			local prevWidth = love.graphics.getLineWidth()
			love.graphics.setLineWidth(3)
			love.graphics.setColor(0, 0, 0)

			local originX = next.SPAWN_X or (ARENA_WIDTH / 2)
			local originY = next.SPAWN_Y or (ARENA_HEIGHT / 2)

			love.graphics.circle("line", originX, originY, self.spawningTimeRemaining * 1200)

			love.graphics.setLineWidth(prevWidth)
		end
	end

	if debug then
		if self.spawning then
			love.graphics.setFont(fonts.small)
			love.graphics.setColor(0, 0, 0)
			local str = string.format("%.2f", self.spawningTimeRemaining)
			love.graphics.print(str, 10, 10)
		end
	end
end

function opponentSpawner:triggerNext(time)
	if self.spawning then return end
	self.spawning = true
	self.spawningTimeRemaining = time
end



classes.opponentSpawner = opponentSpawner
