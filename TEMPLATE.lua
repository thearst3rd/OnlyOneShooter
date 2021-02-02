-- Template object/state class

local TEMPLATE = {}
TEMPLATE.__index = TEMPLATE


--------------------
-- MAIN CALLBACKS --
--------------------

function TEMPLATE.new()
	local self = setmetatable({}, TEMPLATE)
	return self
end

function TEMPLATE:update(dt)
	-- TODO: write this function
end

function TEMPLATE:draw()
	-- TODO: write this function
end


---------------------
-- OTHER CALLBACKS --
---------------------

function TEMPLATE:keypressed(key, scancode, isrepeat)
	-- TODO: write or delete this function
end

-- UNCOMMENT ONE OF THESE
--classes.TEMPLATE = TEMPLATE
--states.TEMPLATE = TEMPLATE
