--[[
-- Copyright Solivis Collective (C) 2025
-- baseplate.luau
--]]

local main = script.Parent

local Bricks = {
	corebricks = {},
	modularbricks = {},

	version = function()
		return "0.0.1BETA"
	end,
}

local clientSided = false
if game:GetService("Players").LocalPlayer ~= nil then
	--We are running on the client
	clientSided = true
end

-- Create the connections
---- Loop through the core bricks.
for _, corebrick in pairs(main.core:GetChildren()) do
	-- Require the bricks
	local required_brick = require(corebrick)

	--Put it into the table
	if required_brick.Init then
		Bricks.corebricks[corebrick.Name] = required_brick

		--Add the state attribute for StateManager to work
		corebrick:SetAttribute("State", "generic")
	else
		error('[Contribengine/baseplate]\nBrick "' .. corebrick.Name .. '" must contain the "Init()" function.')
	end
end
---- Loop through the community bricks.
for _, modularbrick in pairs(main.bricks:GetChildren()) do
	-- Require the bricks
	local required_brick = require(modularbrick)

	--Put it into the table
	if required_brick.Init then
		Bricks.modularbricks[modularbrick.Name] = required_brick

		--Add the state attribute for StateManager to work
		modularbrick:SetAttribute("State", "generic")
	else
		error('[Contribengine/baseplate]\nBrick "' .. modularbrick.Name .. '" must contain the "Init()" function.')
	end
end

--We need to create a list of dependencies, so we can load things optimally.

script:SetAttribute("doneloading", false)

local corecount = 0
for _ in pairs(Bricks.corebricks) do
	corecount += 1
end
local modcount = 0
for _ in pairs(Bricks.modularbricks) do
	modcount += 1
end

--Go through each brick, and put it at the start of the load order if it does not need dependencies, and keep going down until everything is in proper order.
local completed = {}
local loadorder = { core = {}, mod = {} }

--Start with core bricks as they are the most important and do not need anything outside of them
repeat
	for nm, b in pairs(Bricks.corebricks) do
		if #b.DEPENDENCIES == 0 then
			if not table.find(loadorder.core, nm) then
				table.insert(completed, "core/" .. nm)
				table.insert(loadorder.core, nm)
			end
		else
			--Loop through all of it's dependencies and if not all are there then it should skip it
			local passable = true

			for _, d in pairs(b.DEPENDENCIES) do
				if not table.find(completed, d) then
					passable = false
					--Just make sure the dependency even exists
					if not script.Parent.core:FindFirstChild(d:split("/")[2]) then
						if not script.Parent.bricks:FindFirstChild(d:split("/")[2]) then
							--Error it
							error(
								"[Contribengine/baseplate]\nDependency '"
									.. d
									.. "' does not exist. Brick: '"
									.. nm
									.. "'"
							)
						end
					end
					break
				end
			end

			if passable then
				if not table.find(loadorder.core, nm) then
					table.insert(completed, "core/" .. nm)
					table.insert(loadorder.core, nm)
				end
			end
		end
	end
until #loadorder.core == corecount

--Now do community bricks
repeat
	for nm, b in pairs(Bricks.modularbricks) do
		if #b.DEPENDENCIES == 0 then
			if not table.find(loadorder.mod, nm) then
				table.insert(completed, "bricks/" .. nm)
				table.insert(loadorder.mod, nm)
			end
		else
			--Loop through all of it's dependencies and if not all are there then it should skip it
			local passable = true

			for _, d in pairs(b.DEPENDENCIES) do
				if not table.find(completed, d) then
					passable = false
					--Just make sure the dependency even exists
					if not script.Parent.core:FindFirstChild(d:split("/")[2]) then
						if not script.Parent.bricks:FindFirstChild(d:split("/")[2]) then
							--Error it
							error(
								"[Contribengine/baseplate]\nDependency '"
									.. d
									.. "' does not exist. Brick: '"
									.. nm
									.. "'"
							)
						end
					end
					break
				end
			end

			if passable then
				if not table.find(loadorder.mod, nm) then
					table.insert(completed, "bricks/" .. nm)
					table.insert(loadorder.mod, nm)
				end
			end
		end
	end
until #loadorder.mod == modcount

--Finally, we need to actually load them.
--Start with core bricks, then do non-core bricks.
for _, b in pairs(loadorder.core) do
	--Do checks
	local ba = Bricks.corebricks[b]
	if ba.CLIENT_ONLY == true then
		if clientSided == false then
			continue
		end
	elseif ba.SERVER_ONLY == true then
		if clientSided == true then
			continue
		end
	elseif ba.CLIENT_ONLY ~= false and ba.SERVER_ONLY ~= false then
		error("[Contribengine/baseplate]\nBrick cannot be server and client only at the same time")
	end

	Bricks.corebricks[b] = Bricks.corebricks[b].Init(Bricks)
end
--Now we can do modular bricks
for _, b in pairs(loadorder.mod) do
	Bricks.modularbricks[b] = Bricks.modularbricks[b].Init(Bricks)
end

script:SetAttribute("doneloading", true)

-- Return the Bricks so scripts outside of the brick structure can use them.
return Bricks
