--[[
    THIS IS TESTING CODE
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _CONTRIBENGINE = require(ReplicatedStorage.CONTRIBENGINE)

wait(0.5)

_CONTRIBENGINE.corebricks.NetEventSubscriber:Fire("testcross", "ctos", "HI")
