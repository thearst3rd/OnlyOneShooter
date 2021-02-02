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
	self.opponent = classes.opponent.new()
	self.bullets = {}

	return self
end

function game:update(dt)
	-- Update player
	if self.player then
		self.player:update(dt)
		if self.player.markForDeletion then
			self.player = nil
		end
	end

	-- Update opponent
	if self.opponent then
		self.opponent:update(dt)
		if self.opponent.markForDeletion then
			self.opponent = nil
		end
	end

	-- Update bullets (in reverse so deletion works properly)
	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		bullet:update(dt)
		if bullet.markForDeletion then
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
end


---------------------
-- OTHER CALLBACKS --
---------------------

function game:keypressed(key, scancode, isrepeat)
	-- Return to menu
	if key == "escape" then
		state = states.menu.new()
	end
end

states.game = game
