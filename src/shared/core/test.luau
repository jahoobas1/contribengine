--[[
-- Copyright Solivis Collective (C) 2025
-- test.luau
--]]

local module = {}
module.__index = module

function module.Init(bricks)
	local test = {}

	--Put data you may need here.

	setmetatable(test, module)
	return test
end

return module
