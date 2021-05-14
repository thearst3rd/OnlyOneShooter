-- Menu state

local menu = {}
menu.__index = menu


--------------------
-- MAIN CALLBACKS --
--------------------

function menu.new()
	local self = setmetatable({}, menu)

	self.buttons = {
		{x = ARENA_WIDTH / 2 - 200, y = ARENA_HEIGHT / 2, width = 400, height = 28, text = "Play", onPress = function() nextState = states.game.new() end},
		{x = ARENA_WIDTH / 2 - 200, y = ARENA_HEIGHT / 2 + 50, width = 400, height = 28, text = "Options", onPress = function() nextState = states.pause.new(state, true) end},
	}

	return self
end

function menu:update(dt)
	if love.keyboard.isDown("space") then
		nextState = states.game.new()
	end
end

function menu:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("ONLY ONE SHOOTER", 0, 100, ARENA_WIDTH, "center")
	love.graphics.setFont(fonts.medium)
	for _, button in ipairs(self.buttons) do
		drawButton(button)
	end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function menu:keypressed(key, scancode, isrepeat)
	if key == "escape" and not IS_HTML then
		quitGame()
	end
end

function menu:mousepressed(x, y, button, istouch, presses)
	for _, butt in ipairs(self.buttons) do
		checkAndClickButton(x, y, butt)
	end
end

states.menu = menu
