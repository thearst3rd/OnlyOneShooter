-- The Fonts submodule

fonts = {}

function loadFonts()
	local dpiScale = getScaledDpiScale()

	-- Create some fonts
	fonts.small = love.graphics.newFont(14, "normal", dpiScale)
	fonts.medium = love.graphics.newFont(22, "normal", dpiScale)
	fonts.mediumlarge = love.graphics.newFont(28, "normal", dpiScale)
	fonts.large = love.graphics.newFont(40, "normal", dpiScale)
	fonts.title = love.graphics.newFont(96, "normal", dpiScale)
end

-- Get how
function getScaledDpiScale()
	local w, h = love.graphics.getDimensions()
	local scale
	-- Get scale of smaller side
	if (w / h) > (ARENA_WIDTH / ARENA_HEIGHT) then
		scale = h / ARENA_HEIGHT
	else
		scale = w / ARENA_WIDTH
	end

	return love.window.getDPIScale() * scale
end
