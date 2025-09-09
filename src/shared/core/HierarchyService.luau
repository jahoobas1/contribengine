--[[
-- Copyright Solivis Collective (C) 2025
-- HierarchyService.luau
--]]

local module = {}
module.__index = module

module.SERVER_ONLY = false
module.CLIENT_ONLY = false
module.DEPENDENCIES = {}

type prop = {
	Property: string,
	Value: any,
}

type hierarchyobj = {
	className: string,
	props: { prop },
	children: { hierarchyobj },
}

type hierarchy = { hierarchyobj }

function module.Init(bricks)
	local self = {}

	--Put data you may need here.
	self.contribbricks = bricks

	setmetatable(self, module)
	return self
end

--[[
object: The object to check on.<br>
Property: The name of the property to check for.
]]
function module:ContainsProperty(object: Instance, Property: string)
	--[[
        This is NOT my code!
        (I did modify it a tad)
        Credit to:
        https://devforum.roblox.com/t/tutorial-check-if-an-object-has-property/1213998
    ]]

	local success, _ = pcall(function()
		object[Property] = object[Property]

		if object:FindFirstChild(Property) then
			--Create an error to say it's not a property
			--I know this is super hacky but whatever
			object["as" .. tostring(math.random(-2180129, 2180129) + math.random(-2180129, 2180129))] =
				object["dgsjhb" .. tostring(math.random(-2180129, 2180129) + math.random(-2180129, 2180129))]
		end
	end)
	return success
end

--[[
className: The className of the object.<br>
props: The list of every property in the object.<br><br>

Returns the object created.
]]
function module:Object(className: string, props: { prop })
	local newObj = Instance.new(className)

	--Loop through each property and apply it
	for _, property in pairs(props) do
		if module:ContainsProperty(newObj, property.Property) then
			newObj[property.Property] = property.Value
		else
			error(
				"[Contribengine/HierarchyService] Property '"
					.. property.Property
					.. "' does not exist in the '"
					.. className
					.. "' class"
			)
		end
	end

	return newObj
end

--[[
hierarchy: The actual hierarchy of objects to create.
]]
function module:Hierarchy(hierarchy: hierarchy, parent: Instance)
	local function search_hierarchy_obj(nparent: Instance, h: hierarchyobj)
		table.insert(h.props, { Property = "Parent", Value = nparent })

		local root = module:Object(h.className, h.props)

		--Loop through its children
		for _, child in pairs(h.children) do
			search_hierarchy_obj(root, child)
		end
	end

	for _, h in pairs(hierarchy) do
		search_hierarchy_obj(parent, h)
	end
end

return module
