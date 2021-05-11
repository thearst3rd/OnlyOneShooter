-- Manager class that spawns different opponent phases

local opponentSpawner = {}
opponentSpawner.__index = opponentSpawner

function opponentSpawner.new(startIndex)
	local self = setmetatable({}, opponentSpawner)

	self.index = startIndex or 1
	self.list =
	{
		classes.opponentPhaseNoBehavior,
		classes.opponentPhaseNormal,
		classes.opponentPhaseBouncing,
		classes.opponentPhaseOrbit,
		classes.opponentPhaseSpin,
		classes.opponentPhaseCharge,
		classes.opponentPhaseChargeShot,
		classes.opponentPhaseChase,
		classes.opponentPhaseTeleport,
		classes.opponentPhasePortals,
		classes.opponentPhaseFireworkShot,
		classes.opponentPhaseWeakspot,
		classes.opponentPhaseDucks,
		classes.opponentPhaseFakeout,
		classes.opponentPhaseBullethell1,
		classes.opponentPhaseBullethell2,
		classes.opponentPhaseBullethell3,
		classes.opponentPhaseBullethell4,
	}

	self.introText =
	{
		"Hello World", -- Tutorial
		"", -- Space Invaders
		"", -- Bouncing
		"", -- Orbit
		"", -- DVD
		"", -- Charge
		"", -- Charge Shot
		"", -- Chase
		"", -- Teleport
		"This is the part where he kills you", -- Portals
		"", -- Firework
		"", -- Weakspot
		"", -- Ducks
		"", -- Fakeout
		"", -- Bullethell 1
		"", -- Bullethell 2
		"", -- Bullethell 3
		"", -- Bullethell 4
	}

	self.spawning = false
	self.spawningTimeRemaining = 0

	if self.index < 15 then
		musics.musicNormal:play()
	else
		musics.musicBosses:play()
	end

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
				nextState = states.victory.new()
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

			love.graphics.circle("line", originX, originY, (self.spawningTimeRemaining * 30) ^ 2)

			love.graphics.setLineWidth(prevWidth)

			love.graphics.setFont(fonts.large)
			love.graphics.printf(self.introText[self.index], 200, ARENA_HEIGHT / 4, ARENA_WIDTH - 400, "center")
			love.graphics.setFont(fonts.small)
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
