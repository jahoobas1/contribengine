--[[
-- Copyright Solivis Collective (C) 2025
-- EventSubscriber.luau
--]]

local module = {}
module.__index = module

type functionCallback = () -> nil

function module.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.subscriptions = {}

	setmetatable(self, module)
	return self
end

--[[
EventName: The name of the event you want to subscribe to.<br>
Method: How the event works.<br>
----ctoc: <b>Client</b> to <b>Client</b><br>
----ctos: <b>Client</b> to <b>Server</b><br>
----stoc: <b>Server</b> to <b>Client</b><br>
----stos: <b>Server</b> to <b>Server</b><br>
]]
function module:Subscribe(EventName: string, Method: "ctoc" | "ctos" | "stoc" | "stos", Callback: functionCallback)
	if script.Parent.Parent.events:FindFirstChild(Method) then
		local placetocheck = script.Parent.Parent.events[Method]

		if placetocheck:FindFirstChild(EventName) then
			local connection = placetocheck[EventName].Event:Connect(Callback)

			self.subscriptions[EventName] = connection
		else
			warn("Event " .. EventName .. " does not exist in the method: " .. Method)
			return
		end
	end
end

return module
