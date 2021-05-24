-- Handles the settings and config file of OnlyOneShooter

local LIP = require "LIP"

local configDefaults =
{
	soundVolume = 0.7,
	musicVolume = 0.4,
	fullscreen = false,
	alwaysRestart = false,
}

local configFileName = "config.ini"

-- The main table that stores all config data
config = {}

function loadConfig()
	config = {}
	if love.filesystem.getInfo(configFileName) then
		local data = LIP.load(configFileName)
		if data.config then config = data.config end
	end
	for name, value in pairs(configDefaults) do
		if not config[name] then config[name] = value end
	end
	if IS_HTML then config.fullscreen = false end
end

function saveConfig()
	if not config then return end
	LIP.save(configFileName, {config = config})
end

function actOnConfigs()
	refreshAudioVolumes()
	if love.window.getFullscreen() ~= config.fullscreen then
		love.window.setFullscreen(config.fullscreen)
		loadFonts()
	end
end
