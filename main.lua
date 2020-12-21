-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst


-- Load up all classes
classes = {}
require "classes/player"
require "classes/opponent"
require "classes/bullet"

-- Global variables
bullets = {}

-- Define constants
ARENA_WIDTH = 1600
ARENA_HEIGHT = 900

-- Debug variables
debug = false


--------------------
-- MAIN CALLBACKS --
--------------------

function love.load()
	-- Create player
	player = classes.player.new()

	-- Create Opponent
	opponent = classes.opponent.new()

	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)
end

function love.update(dt)
	-- Limit dt
	if dt > 1/15 then dt = 1/15 end

	-- Update player
	if player then
		player:update(dt)
		if player.markForDeletion then
			player = nil
		end
	end

	-- Update opponent
	if opponent then
		opponent:update(dt)
		if opponent.markForDeletion then
			opponent = nil
		end
	end

	-- Update bullets (in reverse so deletion works properly)
	for i = #bullets, 1, -1 do
		local bullet = bullets[i]
		bullet:update(dt)
		if bullet.markForDeletion then
			table.remove(bullets, i)
		end
	end
end

function love.draw()
	-- Draw the bullets
	for _, bullet in ipairs(bullets) do
		bullet:draw()
	end

	-- Draw the player
	if player then player:draw() end

	-- Draw the opponent
	if opponent then opponent:draw() end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "f12" then
		debug = not debug
	end
end


----------------------
-- HELPER FUNCTIONS --
----------------------

function toPolar(x, y)
	local mag = math.sqrt(x * x + y * y)
	local ang = math.atan2(y, x)

	return mag, ang
end

function toCartesian(mag, ang)
	local x = mag * math.cos(ang)
	local y = mag * math.sin(ang)

	return x, y
end
