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

local ARENA_WIDTH = 1600
local ARENA_HEIGHT = 900


function love.load()
	-- Create player
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.radius = 15
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

	-- Collide with walls
	if player.x < player.radius then
		player.x = player.radius
		player.xspeed = 0
	end
	if player.x > ARENA_WIDTH - player.radius then
		player.x = ARENA_WIDTH - player.radius
		player.xspeed = 0
	end
	if player.y < player.radius then
		player.y = player.radius
		player.yspeed = 0
	end
	if player.y > ARENA_HEIGHT - player.radius then
		player.y = ARENA_HEIGHT - player.radius
		player.yspeed = 0
	end

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

	-- Delete off-screen bullets
	for i = #bullets, 1, -1 do
		local bullet = bullets[i]
		if bullet.x < -bullet.radius
				or bullet.x > ARENA_WIDTH + bullet.radius
				or bullet.y < -bullet.radius
				or bullet.y > ARENA_HEIGHT + bullet.radius then
			table.remove(bullets, i)
		end
	end

	-- Create bullets
	if love.mouse.isDown(1)
			and timeSinceLastShot > BULLET_COOLDOWN then
		table.insert(bullets,
		{
			x = player.x,
			y = player.y,
			radius = 8,
			xspeed = BULLET_SPEED * math.cos(aimAng),
			yspeed = BULLET_SPEED * math.sin(aimAng),
		})
		timeSinceLastShot = 0
	end
end

function love.draw()
	-- Draw de playor
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", player.x, player.y, player.radius)

	-- Draw de bullots
	for _, bullet in ipairs(bullets) do
		love.graphics.setColor(0.7, 0.1, 0.1)
		love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
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
