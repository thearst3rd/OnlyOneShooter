-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst

local player = {}
local bullets = {}
local timeSinceLastShot = 0

-- Define constants
local PLAYER_MAXSPEED = 300
local PLAYER_ACCEL = 1000
local PLAYER_FRICTION = 300
local BULLET_SPEED = 200
local BULLET_COOLDOWN = 0.3


function love.load()
	-- Create player
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.size = 20
	player.xspeed = 0
	player.yspeed = 0

	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)
end

function love.update(dt)
	-- Update per-frame variables
	local aimAng = math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
	timeSinceLastShot = timeSinceLastShot + dt

	-- Have player react to keypresses
	local accelVector = {x = 0, y = 0}

	if love.keyboard.isDown("d") then
		accelVector.x = accelVector.x + 1
	end
	if love.keyboard.isDown("a") then
		accelVector.x = accelVector.x - 1
	end
	if love.keyboard.isDown("s") then
		accelVector.y = accelVector.y + 1
	end
	if love.keyboard.isDown("w") then
		accelVector.y = accelVector.y - 1
	end

	if accelVector.x ~= 0 or accelVector.y ~= 0 then
		-- Normalize vector
		local accelMag, accelAng = toPolar(accelVector.x, accelVector.y)
		accelMag = PLAYER_ACCEL

		accelVector.x, accelVector.y = toCartesian(accelMag, accelAng)

		player.xspeed = player.xspeed + accelVector.x * dt
		player.yspeed = player.yspeed + accelVector.y * dt
	end

	local speed = math.sqrt(player.xspeed * player.xspeed + player.yspeed * player.yspeed)
	local ang = math.atan2(player.yspeed, player.xspeed)

	if speed > PLAYER_MAXSPEED then
		speed = PLAYER_MAXSPEED
		player.xspeed = PLAYER_MAXSPEED * math.cos(ang)
		player.yspeed = PLAYER_MAXSPEED * math.sin(ang)
	end

	player.x = player.x + player.xspeed * dt
	player.y = player.y + player.yspeed * dt

	-- Apply friction
	if speed > 0 then
		speed = speed - PLAYER_FRICTION * dt
		if speed < 0 then speed = 0 end
		player.xspeed, player.yspeed = toCartesian(speed, ang)
	end

	-- Update existing bullets
	for _, bullet in ipairs(bullets) do
		bullet.x = bullet.x + bullet.xspeed * dt
		bullet.y = bullet.y + bullet.yspeed * dt
	end

	-- Create bullets
	if love.mouse.isDown(1)
			and timeSinceLastShot > BULLET_COOLDOWN then
		table.insert(bullets,
		{
			x = player.x,
			y = player.y,
			size = 15,
			xspeed = BULLET_SPEED * math.cos(aimAng),
			yspeed = BULLET_SPEED * math.sin(aimAng),
		})
		timeSinceLastShot = 0
	end
end

function love.draw()
	-- Draw de playor
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", player.x, player.y, player.size / 2)

	-- Draw de bullots
	for _, bullet in ipairs(bullets) do
		love.graphics.setColor(0.7, 0.1, 0.1)
		love.graphics.circle("fill", bullet.x, bullet.y, bullet.size / 2)
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
