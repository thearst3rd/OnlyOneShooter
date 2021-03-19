-- The main game state

local game = {}
game.__index = game

-- Define constants
ARENA_WIDTH = 1600
ARENA_HEIGHT = 900


--------------------
-- MAIN CALLBACKS --
--------------------

function game.new(startIndex)
	-- startIndex is optional - used for "continues" to start part way through
	local self = setmetatable({}, game)

	self.player = classes.player.new()
	self.opponentSpawner = classes.opponentSpawner.new(startIndex)
	self.opponent = nil
	self.bullets = {}

	-- Wait a bit to spawn the first enemy
	self.opponentSpawner:triggerNext(1)

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

	-- Update game over timer
	if self.gameOverTimer then
		self.gameOverTimer:update(dt)
		if self.gameOverTimer.markForDeletion then
			if self.gameOverTimer.onDestroy then self.gameOverTimer:onDestroy() end
			self.gameOverTimer = nil
		end
	end
end

function game:draw()
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

	-- Draw the HUD
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
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", 50, ARENA_HEIGHT - 50, 25, 25)
	love.graphics.rectangle("line", 100, ARENA_HEIGHT - 50, 25, 25)
	love.graphics.rectangle("line", 150, ARENA_HEIGHT - 50, 25, 25)
	-- Draw the opponent health bar
	love.graphics.setColor(1, 0, 0)
	if self.opponent then love.graphics.rectangle("fill", 50, 50, (ARENA_WIDTH / 2 - 100) * self.opponent.life / (self.opponent.NUM_LIVES or 6), 25) end
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", 50, 50, ARENA_WIDTH / 2 - 100, 25)

	-- Draw the opponent spawner
	if self.opponentSpawner then self.opponentSpawner:draw() end

	-- Update game over timer
	if self.gameOverTimer then self.gameOverTimer:draw() end
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

states.game = game
