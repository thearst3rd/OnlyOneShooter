-- The pause state

local pause = {}
pause.__index = pause


--------------------
-- MAIN CALLBACKS --
--------------------

function pause.new(savedGame, isMenu)
	local self = setmetatable({}, pause)

	self.gameState = savedGame
	self.isMenu = isMenu or false
	self.pauseButtons = {
		{x = ARENA_WIDTH / 2 - 200, y = 200, width = 400, height = 28, text = "Continue", onPress = function() self:resume() end},
		{x = ARENA_WIDTH / 2 - 200, y = 250, width = 400, height = 28, text = "Options", onPress = function() self.buttons = self.optionButtons end},
		{x = ARENA_WIDTH / 2 - 200, y = 300, width = 400, height = 28, text = "Exit to menu", onPress = function() self:exit() end},
		{x = ARENA_WIDTH / 2 - 200, y = 350, width = 400, height = 28, text = "Quit game", onPress = function() love.event.quit() end},
	}
	self.optionButtons = {
		{x = ARENA_WIDTH / 2 - 200, y = 200, width = 400, height = 28, text = "Toggle Fullscreen", onPress = function() love.window.setFullscreen(not love.window.getFullscreen()) end},
		{x = ARENA_WIDTH / 2 - 200, y = 250, width = 50, height = 28, text = "<", hoverText = "Decrease the volume of all sound effects", onPress = function() self:soundVolumeDown() end},
		{x = ARENA_WIDTH / 2 - 200 + 400 - 50, y = 250, width = 50, height = 28, text = ">", hoverText = "Increase the volume of all sound effects", onPress = function() self:soundVolumeUp() end},
		{x = ARENA_WIDTH / 2 - 140, y = 250, width = 280, height = 28, text = "Sound Vol: x.x", onPress = nil},
		{x = ARENA_WIDTH / 2 - 200, y = 300, width = 50, height = 28, text = "<", hoverText = "Decrease the volume of the music", onPress = function() self:musicVolumeDown() end},
		{x = ARENA_WIDTH / 2 - 200 + 400 - 50, y = 300, width = 50, height = 28, text = ">", hoverText = "Increase the volume of the music", onPress = function() self:musicVolumeUp() end},
		{x = ARENA_WIDTH / 2 - 140, y = 300, width = 280, height = 28, text = "Music Vol: x.x", onPress = nil},
		{x = ARENA_WIDTH / 2 - 200, y = 350, width = 400, height = 28, text = "Toggle Restart Any Time: Off", hoverText = "While off, restricts the keybinds for restarting/continuing to only the player death screen", onPress = function() self:alwaysRestartToggle() end},
		{x = ARENA_WIDTH / 2 - 200, y = 400, width = 400, height = 28, text = "Back", onPress = function() self:backFromOptions() end},
	}
	if self.isMenu then
		self.buttons = self.optionButtons
	else --if not self.isMenu
		self.buttons = self.pauseButtons
	end

	self:setVolumeButtonTexts()
	self:setAlwaysRestartToggleText()

	return self
end

function pause:update(dt)
	-- TODO: write this function
end

function pause:draw()
	if not self.isMenu then
		self.gameState:draw()
	end
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("WASD to move\nMouse to aim\nLeft Click to shoot\nEsc to pause/unpause", ARENA_WIDTH - 300, 100, 300, "center")
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
			self:backFromOptions()
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

function pause:continue()
	if alwaysRestart and not self.isMenu then
		nextState = states.game.new(self.gameState.opponentSpawner.index - 1)
	end
end

function pause:restart()
	if alwaysRestart and not self.isMenu then
		nextState = states.game.new()
	end
end

function pause:exit()
	nextState = states.menu.new()
	musics.musicNormal:stop()
	musics.musicBosses:stop()
end

function pause:soundVolumeDown()
	soundVolume = soundVolume - 0.1
	if soundVolume < 0 then soundVolume = 0 end
	setSoundVolumes(soundVolume)
	self:setVolumeButtonTexts()
end

function pause:soundVolumeUp()
	soundVolume = soundVolume + 0.1
	if soundVolume > 1 then soundVolume = 1 end
	setSoundVolumes(soundVolume)
	self:setVolumeButtonTexts()
end

function pause:musicVolumeDown()
	musicVolume = musicVolume - 0.1
	if musicVolume < 0 then musicVolume = 0 end
	setMusicVolumes(musicVolume)
	self:setVolumeButtonTexts()
end

function pause:musicVolumeUp()
	musicVolume = musicVolume + 0.1
	if musicVolume > 1 then musicVolume = 1 end
	setMusicVolumes(musicVolume)
	self:setVolumeButtonTexts()
end

function pause:alwaysRestartToggle()
	alwaysRestart = not alwaysRestart
	self:setAlwaysRestartToggleText()
end

function pause:setVolumeButtonTexts()
	self.optionButtons[4].text = string.format("Sound Vol: %.1f", soundVolume)
	self.optionButtons[7].text = string.format("Music Vol: %.1f", musicVolume)
end

function pause:setAlwaysRestartToggleText()
	if alwaysRestart then
		self.optionButtons[8].text = "Toggle Restart Any Time: On"
	else --if not alwaysRestart then
		self.optionButtons[8].text = "Toggle Restart Any Time: Off"
	end
end

function pause:backFromOptions()
	if self.isMenu then
		self:resume()
	else --if not self.isMenu
		self.buttons = self.pauseButtons
	end
end

states.pause = pause
