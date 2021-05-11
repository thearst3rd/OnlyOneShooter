-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst


-- Require all helper modules
require "sound"
require "config"

-- Load up all states
states = {}
require "states/menu"
require "states/game"
require "states/pause"
require "states/victory"
require "states/gameOver"
require "states/credits"

-- Load up all classes
classes = {}
require "classes/player"
require "classes/bullet"
require "classes/bulletFirework"
require "classes/bulletPortal"
require "classes/bulletBouncy"
require "classes/opponentSpawner"
require "classes/opponentBase"
require "classes/opponentPhaseNormal"
require "classes/opponentPhaseNoBehavior"
require "classes/opponentPhaseBouncing"
require "classes/opponentPhaseCharge"
require "classes/opponentPhaseChargeShot"
require "classes/opponentPhaseChase"
require "classes/opponentPhaseWeakspot"
require "classes/opponentPhaseFireworkShot"
require "classes/opponentPhaseSpin"
require "classes/opponentPhaseDucks"
require "classes/duck"
require "classes/opponentPhaseOrbit"
require "classes/opponentPhaseTeleport"
require "classes/opponentPhasePortals"
require "classes/opponentPhaseFakeout"
require "classes/opponentPhaseBullethell1"
require "classes/opponentPhaseBullethell2"
require "classes/opponentPhaseBullethell3"
require "classes/opponentPhaseBullethell4"
require "classes/gameOverTimer"
require "classes/portal"

-- Global variables
state = nil 		-- Currently loaded state
nextState = nil 	-- State to load when the frame is done
relMouse = {x = 0, y = 0} 	-- Relative mouse coordinates

-- Screen scaling variables
local targetRatio = (ARENA_WIDTH / ARENA_HEIGHT)
local ratio, scale, xOff, yOff

-- Debug variables
debug = false

-- Assets
images = {}
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

	-- Load images
	images.duck = love.graphics.newImage("images/duck.png")

	loadConfig()
	loadSounds()

	actOnConfigs()

	-- Load menu state
	nextState = states.menu.new()
end

function love.update(dt)
	-- Limit dt
	if dt > 1/15 then dt = 1/15 end

	-- Poll mouse into world-space
	local w, h = love.graphics.getDimensions()
	ratio = w / h

	if ratio > targetRatio then
		-- More wide than 16:9
		scale = h / ARENA_HEIGHT
		xOff = (w - ARENA_WIDTH * scale) / 2
		yOff = 0
	else
		-- More tall than 16:9 (or exactly 16:9)
		scale = w / ARENA_WIDTH
		xOff = 0
		yOff = (h - ARENA_HEIGHT * scale) / 2
	end

	relMouse.x, relMouse.y = love.mouse.getPosition()
	relMouse.x = (relMouse.x - xOff) / scale
	relMouse.y = (relMouse.y - yOff) / scale

	if nextState then
		state = nextState
		nextState = nil
	end

	state:update(dt)
end

function love.draw()
	-- Transform view to best 16:9 view
	love.graphics.translate(xOff, yOff)
	love.graphics.scale(scale)
	state:draw()

	-- Draw black bars
	local w, h = love.graphics.getDimensions()
	love.graphics.origin()
	love.graphics.setColor(0, 0, 0)
	if ratio > targetRatio then
		love.graphics.rectangle("fill", 0, 0, xOff, h)
		love.graphics.rectangle("fill", w-xOff, 0, xOff, h)
	elseif ratio < targetRatio then
		love.graphics.rectangle("fill", 0, 0, w, yOff)
		love.graphics.rectangle("fill", 0, h-yOff, w, yOff)
	end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function love.keypressed(key, scancode, isrepeat)
	if key == "f12" then
		debug = not debug
	elseif key == "return" and love.keyboard.isDown("lalt", "ralt") then
		toggleFullscreen()
	elseif key == "c" then
		if state and state.continue then state:continue() end
	elseif key == "r" then
		if state and state.restart then state:restart() end
	else
		if state and state.keypressed then state:keypressed(key, scancode, isrepeat) end
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	x = (x - xOff) / scale
	y = (y - yOff) / scale
	if state and state.mousepressed then state:mousepressed(x, y, button, istouch, presses) end
end


----------------------
-- HELPER FUNCTIONS --
----------------------

function toPolar(x, y)
	local mag = hypot(x, y)
	local ang = math.atan2(y, x)

	return mag, ang
end

function toCartesian(mag, ang)
	local x = mag * math.cos(ang)
	local y = mag * math.sin(ang)

	return x, y
end

function normalizeAngle(ang)
	while ang > math.pi do
		ang = ang - 2 * math.pi
	end
	while ang <= -math.pi do
		ang = ang + 2 * math.pi
	end
	return ang
end

-- Hypotenuse, https://en.wikipedia.org/wiki/Hypot
function hypot(x, y)
	return math.sqrt(x * x + y * y)
end

function calcDist(x1, y1, x2, y2)
	return hypot(x2 - x1, y2 - y1)
end

function isWithinBox(x, y, x1, y1, width, height)
	return x >= x1 and y >= y1 and x < (x1 + width) and y < (y1 + height)
end

function checkAndClickButton(x, y, button)
	if isWithinBox(x, y, button.x, button.y, button.width, button.height) then
		if button.onPress then button.onPress() end
		return true
	end
	return false
end

function drawButton(button)
	if button.onPress and isWithinBox(relMouse.x, relMouse.y, button.x, button.y, button.width, button.height) then
		love.graphics.setColor(1, 1, 1, 0.3)
		love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
		if button.hoverText then
			love.graphics.setColor(0, 0, 0)
			love.graphics.setFont(fonts.medium)
			love.graphics.printf(button.hoverText, ARENA_WIDTH / 2 + 250, button.y, 250, "left")
		end
	end
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.medium)
	love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
	love.graphics.printf(button.text, button.x, button.y, button.width, "center")
end

function toggleFullscreen()
	config.fullscreen = not config.fullscreen
	actOnConfigs()
end

function quitGame()
	saveConfig()
	love.event.quit()
end
