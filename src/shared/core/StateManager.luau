--[[
-- Copyright Solivis Collective (C) 2025
-- StateManager.luau
--]]

local module = {}
module.__index = module

module.SERVER_ONLY = false
module.CLIENT_ONLY = false
module.DEPENDENCIES = {
	"core/EventSubscriber",
}

type functionCallback = (...any) -> nil

function module.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.contribbricks = bricks

	setmetatable(self, module)
	return self
end

return module
