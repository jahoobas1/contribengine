--[[
    THIS IS TESTING CODE
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _CONTRIBENGINE = require(ReplicatedStorage.CONTRIBENGINE)

_CONTRIBENGINE.corebricks.NetEventSubscriber:Register("testcross", "ctos")

_CONTRIBENGINE.corebricks.NetEventSubscriber:Subscribe("testcross", "ctos", function(plr)
	print("hello world from " .. plr.Name)
end)
