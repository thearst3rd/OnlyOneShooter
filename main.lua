-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst

local balls = {}

local player = {}

-- Define constants
local PLAYER_MAXSPEED = 300
local PLAYER_ACCEL = 1000
local PLAYER_FRICTION = 300


local ballColors =
{
	{1, 0.3, 0.3},
	{1, 1, 0.3},
	{0.3, 1, 0.3},
}


function love.load()
	-- Generate ballz
	for i = 1, 10 do
		balls[i] =
		{
			x = math.random() * love.graphics.getWidth(),
			y = math.random() * love.graphics.getHeight(),
			size = 10 + math.random() * 10,
			xspeed = (math.random() * 400) - 200,
			yspeed = (math.random() * 400) - 200,
			color = ballColors[math.ceil(math.random() * #ballColors)]
		}
	end

	-- Create player
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.size = 20
	player.xspeed = 0
	player.yspeed = 0

	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)
end

function love.update(dt)
	for _, ball in ipairs(balls) do
		ball.x = ball.x + (ball.xspeed * dt)
		ball.y = ball.y + (ball.yspeed * dt)
	end

	-- Apply friction
	local speed, ang = toPolar(player.xspeed, player.yspeed)

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
	else
		speed = speed - (PLAYER_FRICTION * dt)
		if speed < 0 then speed = 0 end

		player.xspeed, player.yspeed = toCartesian(speed, ang)
	end

	speed = math.sqrt(player.xspeed * player.xspeed + player.yspeed * player.yspeed)
	ang = math.atan2(player.yspeed, player.xspeed)

	if speed > PLAYER_MAXSPEED then
		player.xspeed = PLAYER_MAXSPEED * math.cos(ang)
		player.yspeed = PLAYER_MAXSPEED * math.sin(ang)
	end

	player.x = player.x + player.xspeed * dt
	player.y = player.y + player.yspeed * dt
end

function love.draw()
	-- Draw de bawlz
	for _, ball in ipairs(balls) do
		love.graphics.setColor(ball.color)
		love.graphics.circle("fill", ball.x, ball.y, ball.size / 2)
	end

	-- Draw de playor
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", player.x, player.y, player.size / 2)
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
