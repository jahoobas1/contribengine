--[[
-- Copyright Solivis Collective (C) 2025
-- DataService.luau
--]]

local module = {}
module.__index = module

module.SERVER_ONLY = true
module.CLIENT_ONLY = false

local DataStoreService = game:GetService("DataStoreService")

function module.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.contribbricks = bricks

	setmetatable(self, module)
	return self
end

--[[
name: The name of the datastore to retrieve
]]
function module:RetrieveDataStore(name: string)
	return DataStoreService:GetDataStore(name)
end

--[[
ds: The datastore to set the value
key: The key for the data spot
value: The value to set
]]
function module:SetData(ds: DataStore, key: string, value: any)
	local success, errorMessage = pcall(function()
		ds:SetAsync(key, value)
	end)
	if not success then
		error(errorMessage)
	end
end

--[[
ds: The datastore to get the value
key: The key for the data spot
]]
function module:GetData(ds: DataStore, key: string)
	local success, result = pcall(function()
		return ds:GetAsync(key)
	end)
	if not success then
		error(result)
	else
		return result
	end
end

return module
