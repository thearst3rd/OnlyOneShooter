-- The main game state

local game = {}
game.__index = game

-- Define constants
ARENA_WIDTH = 1600
ARENA_HEIGHT = 900


--------------------
-- MAIN CALLBACKS --
--------------------

function game.new()
	local self = setmetatable({}, game)

	self.player = classes.player.new()
	self.opponentSpawner = classes.opponentSpawner.new()
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

	-- Draw the opponent spawner
	if self.opponentSpawner then self.opponentSpawner:draw() end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function game:keypressed(key, scancode, isrepeat)
	-- Pause the game
	if key == "escape" then
		local new_state = states.pause.new(state)
		state = new_state
	end
end

states.game = game
