-- credits state class

local credits = {}
credits.__index = credits


--------------------
-- MAIN CALLBACKS --
--------------------

function credits.new()
	local self = setmetatable({}, credits)

	self.onLicensePage = false

	self.lipLicense = love.filesystem.read("lip-license.txt")
	self.freedoomLicense = love.filesystem.read("freedoom-license.txt")

	self.backButton = {x = 100, y = 235, width = 250, height = 32, text = "Back", onPress = function() self:back() end}
	self.openSourceButton = {x = ARENA_WIDTH / 2 - 150, y = ARENA_HEIGHT - 150, width = 300, height = 32, text = "Open Source Licenses", onPress = function() self.onLicensePage = true end}

	return self
end

function credits:update(dt)
	-- Nothing to do
end

function credits:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.title)
	if self.onLicensePage then
		love.graphics.printf("OPEN SOURCE LICENSES", 0, 100, ARENA_WIDTH, "center")
		love.graphics.setFont(fonts.medium)
		love.graphics.setFont(fonts.large)
		love.graphics.printf("LIP license", 0, 300, ARENA_WIDTH / 2, "center")
		love.graphics.printf("Freedoom license", ARENA_WIDTH / 2, 300, ARENA_WIDTH / 2, "center")
		love.graphics.setFont(fonts.small)
		love.graphics.print(self.lipLicense, 40, 375)
		love.graphics.print(self.freedoomLicense, ARENA_WIDTH / 2 + 40, 375)
	else
		love.graphics.printf("CREDITS", 0, 100, ARENA_WIDTH, "center")
		love.graphics.setFont(fonts.medium)
		love.graphics.printf("For more information, check out:\nhttps://github.com/thearst3rd/OnlyOneShooter",
				0, 220, ARENA_WIDTH, "center")
		love.graphics.setFont(fonts.large)
		love.graphics.printf("Design, Programming, Music, Graphics", 100, 320, ARENA_WIDTH - 200, "center")
		love.graphics.printf("Sounds", 100, 480, ARENA_WIDTH / 2 - 100, "center")
		love.graphics.printf("Special Thanks", ARENA_WIDTH / 2, 480, ARENA_WIDTH / 2 - 100, "center")
		love.graphics.setFont(fonts.mediumlarge)
		love.graphics.printf("Kyle Reese\nTerry Hearst", 100, 380, ARENA_WIDTH - 200, "center")
		love.graphics.printf("Kyle Reese\nTerry Hearst\nThe Motion Monkey\nFreedoom authors\ncrazyduckman",
				100, 540, ARENA_WIDTH / 2 - 100, "center")
		love.graphics.printf("The Love2D Framework\nlove.js for the web port\nLIP - Lua INI Parser\n" ..
				"Terry Cavanagh for Bosca Ceoil\nAnd you!",
				ARENA_WIDTH / 2, 540, ARENA_WIDTH / 2 - 100, "center")
		drawButton(self.openSourceButton)
	end

	drawButton(self.backButton)
end


---------------------
-- OTHER CALLBACKS --
---------------------

function credits:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		self:back()
	end
end

function credits:back()
	if self.onLicensePage then
		self.onLicensePage = false
	else
		nextState = states.menu.new()
	end
end

function credits:mousepressed(x, y, button, istouch, presses)
	checkAndClickButton(x, y, self.backButton)
	if not self.onLicensePage then
		checkAndClickButton(x, y, self.openSourceButton)
	end
end

states.credits = credits
