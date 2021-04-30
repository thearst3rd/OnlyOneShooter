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
		{x = ARENA_WIDTH / 2 - 150, y = 250, width = 50, height = 28, text = "<", onPress = function() self:soundVolumeDown() end},
		{x = ARENA_WIDTH / 2 - 150 + 300 - 50, y = 250, width = 50, height = 28, text = ">", onPress = function() self:soundVolumeUp() end},
		{x = ARENA_WIDTH / 2 - 90, y = 250, width = 180, height = 28, text = "Sound Vol: x.x", onPress = nil},
		{x = ARENA_WIDTH / 2 - 150, y = 300, width = 50, height = 28, text = "<", onPress = function() self:musicVolumeDown() end},
		{x = ARENA_WIDTH / 2 - 150 + 300 - 50, y = 300, width = 50, height = 28, text = ">", onPress = function() self:musicVolumeUp() end},
		{x = ARENA_WIDTH / 2 - 90, y = 300, width = 180, height = 28, text = "Music Vol: x.x", onPress = nil},
		{x = ARENA_WIDTH / 2 - 150, y = 350, width = 300, height = 28, text = "Back", onPress = function() self.buttons = self.pauseButtons end},
	}
	self.buttons = self.pauseButtons

	self:setVolumeButtonTexts()

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
		drawButton(button, button.onPress == nil)
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
	musics.musicNormal:stop()
	musics.musicBosses:stop()
end

function pause:soundVolumeDown()
	soundVolume = soundVolume - 0.1
	if soundVolume < 0 then soundVolume = 1 end
	setSoundVolumes(soundVolume)
	self:setVolumeButtonTexts()
end

function pause:soundVolumeUp()
	soundVolume = soundVolume + 0.1
	if soundVolume > 1 then soundVolume = 0 end
	setSoundVolumes(soundVolume)
	self:setVolumeButtonTexts()
end

function pause:musicVolumeDown()
	musicVolume = musicVolume - 0.1
	if musicVolume < 0 then musicVolume = 1 end
	setMusicVolumes(musicVolume)
	self:setVolumeButtonTexts()
end

function pause:musicVolumeUp()
	musicVolume = musicVolume + 0.1
	if musicVolume > 1 then musicVolume = 0 end
	setMusicVolumes(musicVolume)
	self:setVolumeButtonTexts()
end

function pause:setVolumeButtonTexts()
	self.optionButtons[4].text = string.format("Sound Vol: %.1f", soundVolume)
	self.optionButtons[7].text = string.format("Music Vol: %.1f", musicVolume)
end

states.pause = pause
