-- The pause state

local pause = {}
pause.__index = pause


--------------------
-- MAIN CALLBACKS --
--------------------

function pause.new(savedGame)
	local self = setmetatable({}, pause)

	self.gameState = savedGame
	self.pauseButtons = {
		{x = ARENA_WIDTH / 2 - 150, y = 200, width = 300, height = 28, text = "Continue", onPress = function() self:resume() end},
		{x = ARENA_WIDTH / 2 - 150, y = 250, width = 300, height = 28, text = "Options", onPress = function() self.buttons = self.optionButtons end},
		{x = ARENA_WIDTH / 2 - 150, y = 300, width = 300, height = 28, text = "Exit to menu", onPress = function() self:exit() end},
		{x = ARENA_WIDTH / 2 - 150, y = 350, width = 300, height = 28, text = "Quit game", onPress = function() love.event.quit() end},
	}
	self.optionButtons = {
		{x = ARENA_WIDTH / 2 - 150, y = 200, width = 300, height = 28, text = "Toggle Fullscreen", onPress = function() love.window.setFullscreen(not love.window.getFullscreen()) end},
		{x = ARENA_WIDTH / 2 - 150, y = 250, width = 300, height = 28, text = "Back", onPress = function() self.buttons = self.pauseButtons end},
	}
	self.buttons = self.pauseButtons

	return self
end

function pause:update(dt)
	-- TODO: write this function
end

function pause:draw()
	self.gameState:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("WASD to move\nMouse to aim\nLeft Click to shoot", ARENA_WIDTH - 300, 100, 300, "center")
	for _, button in ipairs(self.buttons) do
		drawButton(button)
	end
end


---------------------
-- OTHER CALLBACKS --
---------------------

function pause:keypressed(key, scancode, isrepeat)
	-- Return to the game
	if key == "escape" then
		if self.buttons == self.optionButtons then
			self.buttons = self.pauseButtons
		else
			self:resume()
		end
	elseif key == "return" then
		self:exit()
	end
end

function pause:mousepressed(x, y, button, istouch, presses)
	for _, butt in ipairs(self.buttons) do
		checkAndClickButton(x, y, butt)
	end
end

function pause:resume()
	nextState = self.gameState
end

function pause:exit()
	nextState = states.menu.new()
	sounds.musicNormal:stop()
	sounds.musicBosses:stop()
end

states.pause = pause
