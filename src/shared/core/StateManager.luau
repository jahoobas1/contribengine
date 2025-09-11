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

local obj

type functionCallback = (...any) -> nil

function module.Init(bricks)
	obj = {}

	--Put data you may need here.
	obj.contribbricks = bricks

	--Initialize StateManager.luau
	obj.clientSided = false

	if game:GetService("Players").LocalPlayer ~= nil then
		obj.clientSided = true
	end

	task.wait(01)

	if obj.clientSided ~= true then
		obj.contribbricks.corebricks.EventSubscriber:Register("StateChanged", "stos")
	else
		obj.contribbricks.corebricks.EventSubscriber:Register("StateChanged", "ctoc")
	end

	setmetatable(obj, module)
	return obj
end

--[[
Is used by StateManager, but is able to be used outside of it.<br><br>

brick: A format of brick indexing that uses the following format: coreornot/brickname<br><br>

core/StateManager<br>
bricks/CommunityBrick
]]
function module:helper_GetBrickByName(brick: string)
	--Bricks should always use this format: coreornot/brickname

	local bricksplit = brick:split("/")

	if #bricksplit == 2 then
		local coreornot = bricksplit[1]
		local brickname = bricksplit[2]

		return script.Parent.Parent[coreornot][brickname]
	else
		error("[Contribengine/StateManager]\nBrick name does not follow the 'coreornot/brickname' format.")
	end
end

--[[
s: The name of the script calling the function.
]]
function module.GetInterface(s: Script)
	local interface = {}

	--[[
    brick: A format of brick indexing that uses the following format: coreornot/brickname<br><br>

    core/StateManager<br>
    bricks/CommunityBrick
    ]]
	function interface:GetBrickState(brick: string)
		local b = module:helper_GetBrickByName(brick)

		return b:GetAttribute("State")
	end

	--[[
    state: The text that you want the current brick's state to be.
    ]]
	function interface:SetBrickState(state: string)
		s:SetAttribute(state)

		obj.contribbricks.corebricks.EventSubscriber:Fire("StateChanged", s, state)
	end

	--[[
    brick: A format of brick indexing that uses the following format: coreornot/brickname<br><br>

    core/StateManager<br>
    bricks/CommunityBrick
    ]]
	function interface:OnBrickStateUpdate(brick: string, func: functionCallback)
		local b = module:helper_GetBrickByName(brick)

		obj.contribbricks.corebricks.EventSubscriber:Subscribe("StateChanged", function(s2: Script, ...)
			if s2 == b then
				func(...)
			end
		end)
	end

	return interface
end

return module
