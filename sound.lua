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
	loadSound("duckHit", 0.4)
	loadSound("duckDeath", 0.4)

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

-- Music resumes at a phrase mark when unpaused
local musicDriveMeasure = 4 * (60/125) -- how long one measure is in seconds
local musicDriveCheckpoints =
{
	4 * musicDriveMeasure,
	8 * musicDriveMeasure,
	12 * musicDriveMeasure,
}

local musicRushMeasure = 8 * (60/180)
local musicRushCheckpoints =
{
	2 * musicRushMeasure,
	6 * musicRushMeasure,
	10 * musicRushMeasure,
	18 * musicRushMeasure,
	26 * musicRushMeasure,
}

function musicGetPlaying()
	if musics.musicNormal:isPlaying() then
		return musics.musicNormal
	end
	if musics.musicBosses:isPlaying() then
		return musics.musicBosses
	end
	return nil
end

function musicPauseAndCheckpoint()
	local music = musicGetPlaying()
	if music then
		music:pause()
		music:seek(musicCalculateCheckpoint(music))
	end
end

function musicCalculateCheckpoint(music)
	local checkpoints = nil
	if music == musics.musicNormal then checkpoints = musicDriveCheckpoints end
	if music == musics.musicBosses then checkpoints = musicRushCheckpoints end
	if not checkpoints then return 0 end

	local pos = music:tell("seconds")
	local newPos = 0
	for _, checkpoint in ipairs(checkpoints) do
		if checkpoint > pos then break end
		newPos = checkpoint
	end
	return newPos
end
