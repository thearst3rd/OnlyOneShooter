-- The main game state

local game = {}
game.__index = game

-- Define constants
ARENA_WIDTH = 1600
ARENA_HEIGHT = 900

local SCREEN_SHAKE_PERIOD = 1/24


--------------------
-- MAIN CALLBACKS --
--------------------

function game.new(startIndex)
	-- startIndex is optional - used for "continues" to start part way through
	local self = setmetatable({}, game)

	if not startIndex then
		musics.musicNormal:stop()
		musics.musicBosses:stop()
		musics.musicNormal:seek(0)
		musics.musicBosses:seek(0)
	end

	self.player = classes.player.new()
	self.opponentSpawner = classes.opponentSpawner.new(startIndex)
	self.opponent = nil
	self.bullets = {}
	self.particles = {}

	-- Wait a bit to spawn the first enemy
	self.opponentSpawner:triggerNext(2)

	self.screenShakeDuration = 0
	self.screenShakeIntensity = 0
	self.screenShakeOffsetX = 0
	self.screenShakeOffsetY = 0
	self.screenShakeCalcOffsetTime = 0

	return self
end

function game:update(dt)
	-- Update player
	if self.player then
		self.player:update(dt)
		if self.player.markForDeletion then
			if self.player.onDestroy then self.player:onDestroy() end
			self.player = nil
		end
	end

	-- Update opponent
	if self.opponent then
		self.opponent:update(dt)
		if self.opponent.markForDeletion then
			if self.opponent.onDestroy then self.opponent:onDestroy() end
			self.opponent = nil
		end
	end

	-- Update portals
	if self.bluePortal then
		self.bluePortal:update(dt)
		if self.bluePortal.markForDeletion then
			if self.bluePortal.onDestroy then self.bluePortal:onDestroy() end
			self.bluePortal = nil
		end
	end

	if self.orangePortal then
		self.orangePortal:update(dt)
		if self.orangePortal.markForDeletion then
			if self.orangePortal.onDestroy then self.orangePortal:onDestroy() end
			self.orangePortal = nil
		end
	end

	-- Update opponent spawner
	if self.opponentSpawner then
		self.opponentSpawner:update(dt)
		if self.opponentSpawner.markForDeletion then
			if self.opponentSpawner.onDestroy then self.opponentSpawner:onDestroy() end
			self.opponentSpawner = nil
		end
	end

	-- Update bullets (in reverse so deletion works properly)
	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		bullet:update(dt)
		if bullet.markForDeletion then
			if bullet.onDestroy then bullet:onDestroy() end
			table.remove(self.bullets, i)
		end
	end

	-- Update particles (in reverse so deletion works properly)
	for i = #self.particles, 1, -1 do
		local particle = self.particles[i]
		particle:update(dt)
		if particle.markForDeletion then
			if particle.onDestroy then particle:onDestroy() end
			table.remove(self.particles, i)
		end
	end

	-- Update game over timer
	if self.gameOverTimer then
		self.gameOverTimer:update(dt)
		if self.gameOverTimer.markForDeletion then
			if self.gameOverTimer.onDestroy then self.gameOverTimer:onDestroy() end
			self.gameOverTimer = nil
		end
	end

	-- Update screen shaking
	if self.screenShakeDuration > 0 then
		self.screenShakeDuration = self.screenShakeDuration - dt
		if self.screenShakeDuration <= 0 then
			self.screenShakeDuration = 0
			self.screenShakeOffsetX = 0
			self.screenShakeOffsetY = 0
		else
			self.screenShakeCalcOffsetTime = self.screenShakeCalcOffsetTime - dt
			if self.screenShakeCalcOffsetTime <= 0 then
				self.screenShakeCalcOffsetTime = self.screenShakeCalcOffsetTime + SCREEN_SHAKE_PERIOD
				local ang = love.math.random() * 2 * math.pi
				self.screenShakeOffsetX = self.screenShakeIntensity * math.cos(ang)
				self.screenShakeOffsetY = self.screenShakeIntensity * math.sin(ang)
			end
		end
	end
end

function game:draw()
	love.graphics.push()
	love.graphics.translate(self.screenShakeOffsetX, self.screenShakeOffsetY)

	-- Draw the bullets
	for _, bullet in ipairs(self.bullets) do
		bullet:draw()
	end

	-- Draw the player
	if self.player then self.player:draw() end

	-- Draw the opponent
	if self.opponent then self.opponent:draw() end

	-- Draw the portals
	if self.bluePortal then self.bluePortal:draw() end
	if self.orangePortal then self.orangePortal:draw() end

	-- Draw the opponent spawner
	if self.opponentSpawner then self.opponentSpawner:draw() end

	-- Draw the particles
	for _, particle in ipairs(self.particles) do
		particle:draw()
	end

	-- HUD code begins here

	-- Draw the player lives
	love.graphics.setColor(1, 0, 0)
	if self.player then
		if self.player.health >= 1 then
			love.graphics.rectangle("fill", 50, ARENA_HEIGHT - 50, 25, 25)
		end
		if self.player.health >= 2 then
			love.graphics.rectangle("fill", 100, ARENA_HEIGHT - 50, 25, 25)
		end
		if self.player.health == 3 then
			love.graphics.rectangle("fill", 150, ARENA_HEIGHT - 50, 25, 25)
		end
	end

	-- Update game over timer
	if self.gameOverTimer then self.gameOverTimer:draw() end

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", 50, ARENA_HEIGHT - 50, 25, 25)
	love.graphics.rectangle("line", 100, ARENA_HEIGHT - 50, 25, 25)
	love.graphics.rectangle("line", 150, ARENA_HEIGHT - 50, 25, 25)
	-- Draw the opponent health bar
	love.graphics.setColor(1, 0, 0)
	if self.opponent then love.graphics.rectangle("fill", 50, 50, (ARENA_WIDTH / 2 - 100) * self.opponent.life / (self.opponent.NUM_LIVES or 8), 25) end
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", 50, 50, ARENA_WIDTH / 2 - 100, 25)

	love.graphics.pop()
end


---------------------
-- OTHER CALLBACKS --
---------------------

function game:keypressed(key, scancode, isrepeat)
	-- Pause the game
	if key == "escape" then
		nextState = states.pause.new(state)
	end
end

function game:continue()
	if config.alwaysRestart and state.opponent then
		nextState = states.game.new(state.opponentSpawner.index - 1)
	end
end

function game:restart()
	if config.alwaysRestart then
		nextState = states.game.new()
	end
end

function game:screenShake(duration, intensity)
	self.screenShakeDuration = duration or 0.2
	self.screenShakeIntensity = intensity or 5
	if self.screenShakeDuration > 0 then
		self.screenShakeCalcOffsetTime = SCREEN_SHAKE_PERIOD
		local ang = love.math.random() * 2 * math.pi
		self.screenShakeOffsetX = self.screenShakeIntensity * math.cos(ang)
		self.screenShakeOffsetY = self.screenShakeIntensity * math.sin(ang)
	else
		self.screenShakeOffsetX = 0
		self.screenShakeOffsetY = 0
	end
end

states.game = game
