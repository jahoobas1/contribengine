--[[
-- Copyright Solivis Collective (C) 2025
-- EventSubscriber.luau
--]]

local module = {}
module.__index = module

module.SERVER_ONLY = false
module.CLIENT_ONLY = false
module.DEPENDENCIES = {
	"core/HierarchyService",
}

type functionCallback = () -> nil

function module.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.subscriptions = {}
	self.events = {}

	self.contribbricks = bricks

	setmetatable(self, module)
	return self
end

--[[
EventName: The name of the event you want to subscribe to.<br>
Method: How the event works.<br><br>

ctoc: <b>Client</b> to <b>Client</b><br>
ctos: <b>Client</b> to <b>Server</b><br>
stoc: <b>Server</b> to <b>Client</b><br>
stos: <b>Server</b> to <b>Server</b><br>
<br>
Callback: The function to run when the event is fired.
]]
function module:Subscribe(EventName: string, Method: "ctoc" | "ctos" | "stoc" | "stos", Callback: functionCallback)
	if script.Parent.Parent.events:FindFirstChild(Method) then
		local placetocheck = script.Parent.Parent.events[Method]

		if placetocheck:FindFirstChild(EventName) then
			local connection = placetocheck[EventName].Event:Connect(Callback)

			self.subscriptions[EventName] = connection
		else
			warn("[Contribengine/EventSubscriber] Event " .. EventName .. " does not exist in the method: " .. Method)
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
		warn("[Contribengine/EventSubscriber] Current object is not subscribed to event " .. EventName)
		return
	end
end

--[[
EventName: The name of the event you want to fire.
]]
function module:Fire(EventName: string)
	if self.events[EventName] ~= nil then
		self.events[EventName]:Fire()
	else
		warn("[Contribengine/EventSubscriber] Current object does not have an event registered named " .. EventName)
		return
	end
end

--[[
EventName: The name of the event you want to register.<br>
Method: How you want the event to be fired.<br><br>

ctoc: <b>Client</b> to <b>Client</b><br>
ctos: <b>Client</b> to <b>Server</b><br>
stoc: <b>Server</b> to <b>Client</b><br>
stos: <b>Server</b> to <b>Server</b>
]]
function module:Register(EventName: string, Method: "ctoc" | "ctos" | "stoc" | "stos")
	local placetocheck = script.Parent.Parent.events[Method]

	if not placetocheck:FindFirstChild(EventName) then
		--Use HierarchyService to create our event
		if Method == "ctoc" or Method == "stos" then
			--Bindable event
			local new = self.contribbricks.corebricks.HierarchyService:Object("BindableEvent", {
				{ Property = "Name", Value = EventName },
				{ Property = "Parent", Value = placetocheck },
			})

			self.events[EventName] = new
		else
			--Remote event
			local new = self.contribbricks.corebricks.HierarchyService:Object("RemoteEvent", {
				{ Property = "Name", Value = EventName },
				{ Property = "Parent", Value = placetocheck },
			})

			self.events[EventName] = new
		end
	else
		warn(
			"[Contribengine/EventSubscriber] An event named "
				.. EventName
				.. " already exists. Please choose another name."
		)
		return
	end
end

--[[
EventName: The name of the event you want to unregister.<br>
Method: How the event is fired.
]]
function module:Unregister(EventName: string, Method: "ctoc" | "ctos" | "stoc" | "stos")
	local placetocheck = script.Parent.Parent.events[Method]

	if placetocheck:FindFirstChild(EventName) then
		self.events[EventName]:Destroy()

		self.events[EventName] = nil
	else
		warn("[Contribengine/EventSubscriber] An event named " .. EventName .. " does not exist.")
		return
	end
end

return module
