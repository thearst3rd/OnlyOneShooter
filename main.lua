-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst

local player = {}
local opponent = {}
local bullets = {}
local timeSinceLastShot = 0
local opponentShotCooldown = 0
local opponentAdvanceDist = 0
local bulletsOut = 0

-- Define constants
local PLAYER_MAXSPEED = 450
local PLAYER_ACCEL = 900
local PLAYER_FRICTION = 150
local PLAYER_BULLET_SPEED = 1000
local PLAYER_BULLET_COOLDOWN = 0.25
local OPPONENT_SPEED = 200
local OPPONENT_BULLET_SPEED = 250
local OPPONENT_BULLET_COOLDOWN = 1

local ARENA_WIDTH = 1600
local ARENA_HEIGHT = 900

local debug = false
local opponentiFrameToggle = false


--------------------
-- MAIN CALLBACKS --
--------------------

function love.load()
	-- Create player
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.radius = 15
	player.xspeed = 0
	player.yspeed = 0
	player.angle = 0

	-- Create Opponent
	opponent.radius = 25
	opponent.x = love.graphics.getWidth() - opponent.radius * 4
	opponent.y = opponent.radius * 4
	opponent.xspeed = 0
	opponent.yspeed = 0
	opponent.direction = false
	opponent.advance = false
	opponent.life = 3

	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)
end

function love.update(dt)
	-- Limit dt
	if dt > 1/15 then dt = 1/15 end

	-- Update player values
	player.angle = math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
	timeSinceLastShot = timeSinceLastShot + dt

	-- Update opponent values
	opponentShotCooldown = opponentShotCooldown + dt
	opponentAdvanceDist = opponentAdvanceDist + OPPONENT_SPEED * dt
	bulletsOut = 0

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

	-- Update opponent movement
	if not opponent.advance then
		if opponent.direction then
			opponent.x = opponent.x + OPPONENT_SPEED * dt
		else
			opponent.x = opponent.x - OPPONENT_SPEED * dt
		end
	else
		opponent.y = opponent.y + OPPONENT_SPEED * dt
	end

	if opponent.x - opponent.radius <= 0 then opponent.direction = true end
	if opponent.x + opponent.radius >= ARENA_WIDTH then
		opponent.advance = true
		opponent.direction = false
	end

	if opponentAdvanceDist >= 125 then
		opponent.advance = false
		opponentAdvanceDist = 0
	end

	-- Update opponent living status
	for _, bullet in ipairs(bullets) do
		if bullet.friendly then
			if math.sqrt((opponent.x - bullet.x) ^ 2 + (opponent.y - bullet.y) ^ 2) <= opponent.radius + bullet.radius and not opponentiFrameToggle then
				opponent.life = opponent.life - 1
				opponentiFrameToggle = true
			elseif math.sqrt((opponent.x - bullet.x) ^ 2 + (opponent.y - bullet.y) ^ 2) > opponent.radius + bullet.radius then
				bulletsOut = bulletsOut + 1
			end
		else
			bulletsOut = bulletsOut + 1
		end
	end
	if bulletsOut == #bullets then
		opponentiFrameToggle = false
		bulletsOut = 0
	end

	if opponent.life == 0 then
		-- This teleport should be temporary, we should just not draw the sprite during this time
		opponent.x = -100
		opponent.y = -100
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
			and timeSinceLastShot > PLAYER_BULLET_COOLDOWN then
		table.insert(bullets,
		{
			x = player.x,
			y = player.y,
			radius = 8,
			xspeed = PLAYER_BULLET_SPEED * math.cos(player.angle),
			yspeed = PLAYER_BULLET_SPEED * math.sin(player.angle),
			friendly = true,
		})
		timeSinceLastShot = 0
	end
	if opponentShotCooldown > OPPONENT_BULLET_COOLDOWN then
		table.insert(bullets,
		{
			x = opponent.x,
			y = opponent.y,
			radius = 8,
			xspeed = 0,
			yspeed = OPPONENT_BULLET_SPEED,
			friendly = false,
		})
		opponentShotCooldown = 0
	end
end

local playerPolygon =
{
	30, 0,
	-20, 15,
	-12, 0,
	-20, -15,
	30, 0,
}

local playerPolygonTri = love.math.triangulate(playerPolygon)

function love.draw()
	-- Draw the bullets
	for _, bullet in ipairs(bullets) do
		love.graphics.setColor(0.7, 0.1, 0.1)
		love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
	end

	-- Draw the player
	love.graphics.push()
		love.graphics.translate(player.x, player.y)
		love.graphics.rotate(player.angle)

		love.graphics.setColor(1, 1, 1)
		for _, poly in ipairs(playerPolygonTri) do
			love.graphics.polygon("fill", poly)
		end

		local width = love.graphics.getLineWidth()
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0, 0, 0)
		love.graphics.line(playerPolygon)
		love.graphics.setLineWidth(width)
	love.graphics.pop()

	-- Debug player hitbox
	if debug then
		love.graphics.setColor(1, 0, 0)
		love.graphics.circle("line", player.x, player.y, player.radius)
	end

	-- Draw the opponent
	love.graphics.setColor(0.1, 0.4, 0.7)
	love.graphics.circle("fill", opponent.x, opponent.y, opponent.radius)
end


---------------------
-- OTHER CALLBACKS --
---------------------

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "f12" then
		debug = not debug
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
