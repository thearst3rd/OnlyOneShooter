-- D U C K S   B A Y B E

local opponentPhaseDucks = {}
opponentPhaseDucks.__index = opponentPhaseDucks

opponentPhaseDucks.DEFAULT_BULLET_COOLDOWN = 0.4
opponentPhaseDucks.DEFAULT_BULLET_SPEED = 500
opponentPhaseDucks.INTRO_TEXT = "Quack"


local NUM_DUCKS = 40
local MAX_TURN_SPEED = 2

--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseDucks.new()
	local self = classes.opponentBase.new(opponentPhaseDucks)

	self.ducks = {}
	local tempDucks = {}
	for i = 1, NUM_DUCKS do
		local ang = normalizeAngle(2 * math.pi * i / NUM_DUCKS)
		local duck = classes.duck.new(ang, self.x, self.y)
		table.insert(tempDucks, duck)
	end
	-- Shuffle the table, so the ducks draw on top of each other randomly
	while #tempDucks > 0 do
		local ind = love.math.random(#tempDucks)
		local duck = table.remove(tempDucks, ind)
		table.insert(self.ducks, duck)
	end

	if state.player then
		self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	end

	return self
end

function opponentPhaseDucks:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	-- Update ducks
	for i = #self.ducks, 1, -1 do
		self.ducks[i]:update(dt)
		if self.ducks[i].markForDeletion then
			table.remove(self.ducks, i)
		end
	end

	if self.stunned then return end

	if not state.player then return end

	local newAngle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	local diff = normalizeAngle(newAngle - self.angle)
	if diff > MAX_TURN_SPEED * dt then
		self.angle = normalizeAngle(self.angle + MAX_TURN_SPEED * dt)
	elseif diff < -MAX_TURN_SPEED then
		self.angle = normalizeAngle(self.angle - MAX_TURN_SPEED * dt)
	else
		self.angle = newAngle
	end
end

function opponentPhaseDucks:draw()
	-- Draw ducks
	for _, duck in ipairs(self.ducks) do
		duck:draw()
	end

	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseDucks:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseDucks = opponentPhaseDucks
