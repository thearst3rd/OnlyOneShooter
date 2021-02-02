-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst


-- Load up all classes
classes = {}
require "classes/player"
require "classes/bullet"
require "classes/opponentSpawner"
require "classes/opponentBase"
require "classes/opponentPhaseNormal"
require "classes/opponentPhaseNoBehavior"

-- Load up all states
states = {}
require "states/menu"
require "states/game"

-- Global variables
state = nil 	-- Currently loaded state

-- Debug variables
debug = false


--------------------
-- MAIN CALLBACKS --
--------------------

function love.load()
	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)

	-- Load menu state
	state = states.menu.new()
end

function love.update(dt)
	-- Limit dt
	if dt > 1/15 then dt = 1/15 end

	if state and state.update then
		state:update(dt)
	end
end

function love.draw()
	if state and state.draw then
		state:draw()
	end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function love.keypressed(key, scancode, isrepeat)
	if key == "f12" then
		debug = not debug
	elseif state and state.keypressed then
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
