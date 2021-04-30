-- Module that handles sound-related functionality

sounds = {}
soundVolumes = {}
musics = {}
musicVolumes = {}

soundVolume = 0.7
musicVolume = 0.4

local function loadSound(name, volume, sourceType)
	volume = volume or 1
	sourceType = sourceType or "static"
	filename = "sounds/" .. name .. ".wav"
	sounds[name] = love.audio.newSource(filename, sourceType)
	soundVolumes[name] = volume
end

local function loadMusic(name, filename, volume, sourceType)
	volume = volume or 1
	sourceType = sourceType or "stream"
	musics[name] = love.audio.newSource(filename, sourceType)
	musics[name]:setLooping(true)
	musicVolumes[name] = volume
end

function loadSounds()
	loadSound("playerHit")
	loadSound("playerDeath")
	loadSound("opponentHit")
	loadSound("opponentDeath")
	loadSound("opponentDeathEpic")
	loadSound("bulletBounce", 0.1)
	loadSound("bulletFireworkPopping")
	loadSound("bulletFiringFriendly", 0.5)
	loadSound("bulletFiringOpponent", 0.3)
	loadSound("bulletFiringOpponentBouncy", 0.35)
	loadSound("bulletFiringOpponentFirework", 0.35)
	loadSound("bulletFiringOpponentLarge")
	loadSound("bulletFiringOpponentPortal", 0.6)
	loadSound("ineffectiveOpponentDamage", 0.6)
	loadSound("portalOpening", 0.55)
	loadSound("teleport", 0.25)
	loadSound("duck")

	loadMusic("musicNormal", "sounds/music_drive.ogg")
	loadMusic("musicBosses", "sounds/music_rush.ogg")

	setSoundVolumes(soundVolume)
	setMusicVolumes(musicVolume)
end

-- Set all source volumes
function setSoundVolumes(multiplier)
	for name, sound in pairs(sounds) do
		sound:setVolume(soundVolumes[name] * multiplier)
	end
end

function setMusicVolumes(multiplier)
	for name, sound in pairs(musics) do
		sound:setVolume(musicVolumes[name] * multiplier)
	end
end

