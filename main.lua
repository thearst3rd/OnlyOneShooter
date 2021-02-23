-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst


-- Load up all states
states = {}
require "states/menu"
require "states/game"
require "states/pause"
require "states/victory"
require "states/gameOver"

-- Load up all classes
classes = {}
require "classes/player"
require "classes/bullet"
require "classes/opponentSpawner"
require "classes/opponentBase"
require "classes/opponentPhaseNormal"
require "classes/opponentPhaseNoBehavior"
require "classes/opponentPhaseBouncing"
require "classes/opponentPhaseSpin"
require "classes/opponentPhaseOrbit"
require "classes/gameOverTimer"

-- Global variables
state = nil 	-- Currently loaded state

-- Debug variables
debug = false

-- Fonts
fonts = {}


--------------------
-- MAIN CALLBACKS --
--------------------

function love.load()
	-- Set default background color
	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)

	-- Create some fonts
	fonts.small = love.graphics.newFont(14)
	fonts.medium = love.graphics.newFont(22)
	fonts.large = love.graphics.newFont(40)
	fonts.title = love.graphics.newFont(96)

	-- Load menu state
	state = states.menu.new()
end

function love.update(dt)
	-- Limit dt
	if dt > 1/15 then dt = 1/15 end

	state:update(dt)
end

function love.draw()
	state:draw()
end


---------------------
-- OTHER CALLBACKS --
---------------------

function love.keypressed(key, scancode, isrepeat)
	if key == "f12" then
		debug = not debug
	else
		state:keypressed(key, scancode, isrepeat)
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
