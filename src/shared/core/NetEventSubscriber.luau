--[[
-- Copyright Solivis Collective (C) 2025
-- NetEventSubscriber.luau
--]]

local module = {}
module.__index = module

module.SERVER_ONLY = false
module.CLIENT_ONLY = false
module.DEPENDENCIES = {
	"core/HierarchyService",
}

type functionCallback = (...any) -> nil

function module.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.subscriptions = {}
	self.events = {}

	self.contribbricks = bricks

	self.client = false
	if game:GetService("Players").LocalPlayer ~= nil then
		self.client = true
	end

	setmetatable(self, module)
	return self
end

--[[
EventName: The name of the event you want to subscribe to.<br>
Method: How the event works.<br><br>

ctos: <b>Client</b> to <b>Server</b><br>
stoc: <b>Server</b> to <b>Client</b><br>
<br>
Callback: The function to run when the event is fired.
]]
function module:Subscribe(EventName: string, Method: "ctos" | "stoc", Callback: functionCallback)
	if script.Parent.Parent.events:FindFirstChild(Method) then
		local placetocheck = script.Parent.Parent.events[Method]

		if placetocheck:FindFirstChild(EventName) then
			local connection

			if Method == "ctos" then
				connection = placetocheck[EventName].OnServerEvent:Connect(Callback)
			else
				connection = placetocheck[EventName].OnClientEvent:Connect(Callback)
			end

			self.subscriptions[EventName] = connection
		else
			warn(
				"[Contribengine/NetEventSubscriber]\nEvent " .. EventName .. " does not exist in the method: " .. Method
			)
			return
		end
	end
end

--[[
EventName: The name of the event you want to unsubscribe from.
]]
function module:Unsubscribe(EventName: string)
	if self.subscriptions[EventName] ~= nil then
		self.subscriptions[EventName]:Disconnect()

		self.subscriptions[EventName] = nil
	else
		warn("[Contribengine/NetEventSubscriber]\nCurrent object is not subscribed to event " .. EventName)
		return
	end
end

--[[
EventName: The name of the event you want to fire.
Method: How the event works.<br><br>

ctos: <b>Client</b> to <b>Server</b><br>
stoc: <b>Server</b> to <b>Client</b>

...: The arguments for the event.
<br><br>
If you are calling this from the server, you should specify what player this is targeting.
]]
function module:Fire(EventName: string, Method: "stoc" | "ctos", ...)
	if script.Parent.Parent.events[Method]:FindFirstChild(EventName) then
		if self.client == true then
			script.Parent.Parent.events[Method]:FindFirstChild(EventName):FireServer(...)
		else
			script.Parent.Parent.events[Method]:FindFirstChild(EventName):FireClient(...)
		end
	else
		warn(
			"[Contribengine/NetEventSubscriber]\nThere is no event registered named "
				.. EventName
				.. " in the context of "
				.. Method
		)
		return
	end
end

--[[
EventName: The name of the event you want to register.<br>
Method: How you want the event to be fired.<br><br>

ctos: <b>Client</b> to <b>Server</b><br>
stoc: <b>Server</b> to <b>Client</b>
]]
function module:Register(EventName: string, Method: "ctos" | "stoc")
	local placetocheck = script.Parent.Parent.events[Method]

	if not placetocheck:FindFirstChild(EventName) then
		--Use HierarchyService to create our event
		local new = self.contribbricks.corebricks.HierarchyService:Object("RemoteEvent", {
			{ Property = "Name", Value = EventName },
			{ Property = "Parent", Value = placetocheck },
		})

		self.events[EventName] = new
	else
		warn(
			"[Contribengine/NetEventSubscriber]\nAn event named "
				.. EventName
				.. " already exists. Please choose another name."
		)
		return
	end
end

--[[
EventName: The name of the event you want to unregister.<br>
Method: How the event is fired.<br><br>

ctos: <b>Client</b> to <b>Server</b><br>
stoc: <b>Server</b> to <b>Client</b>
]]
function module:Unregister(EventName: string, Method: "ctos" | "stoc")
	local placetocheck = script.Parent.Parent.events[Method]

	if placetocheck:FindFirstChild(EventName) then
		self.events[EventName]:Destroy()

		self.events[EventName] = nil
	else
		warn("[Contribengine/NetEventSubscriber]\nAn event named " .. EventName .. " does not exist.")
		return
	end
end

return module
