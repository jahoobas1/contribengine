--This is a template. Feel free to use it!
--Please know that everything in this code is entirely required for Contribengine to work with it. Otherwise it will not work.

local BRICK = {}
BRICK.__index = BRICK

BRICK.SERVER_ONLY = true
BRICK.CLIENT_ONLY = false
BRICK.DEPENDENCIES = {}

function BRICK.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.contribbricks = bricks

	setmetatable(self, BRICK)
	return self
end

return BRICK
