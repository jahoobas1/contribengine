--[[
-- Copyright Solivis Collective (C) 2025
-- baseplate.luau
--]]

local main = script.Parent

local Bricks = {
	corebricks = {},
	modularbricks = {},
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
	else
		error('[Contribengine/baseplate] Brick "' .. corebrick.Name .. '" must contain the "Init()" function.')
	end
end
---- Loop through the community bricks.
for _, modularbrick in pairs(main.bricks:GetChildren()) do
	-- Require the bricks
	local required_brick = require(modularbrick)

	--Put it into the table
	if required_brick.Init then
		Bricks.modularbricks[modularbrick.Name] = required_brick
	else
		error('[Contribengine/baseplate] Brick "' .. modularbrick.Name .. '" must contain the "Init()" function.')
	end
end
----Then, we need to go through each one, initialize it and reregister it.
for nm, cb in pairs(Bricks.corebricks) do
	if cb.CLIENT_ONLY == cb.SERVER_ONLY then
		--It should be false
		if cb.CLIENT_ONLY ~= false then
			error("[Contribengine/baseplate] Brick cannot be client only and server only at the same time")
		end
	else
		if cb.CLIENT_ONLY == true then
			if clientSided == false then
				continue
			end
		elseif cb.SERVER_ONLY == true then
			if clientSided == true then
				continue
			end
		end
	end

	--Check dependencies
	for _, depend in pairs(cb.DEPENDENCIES) do
		local deptable = depend:split("/")

		local t = deptable[1]
		local dependency = deptable[2]

		if Bricks[t .. "bricks"] then
			if not Bricks[t .. "bricks"][dependency] then
				error("Missing dependency: " .. depend)
			end
		else
			error("[Contribengine/baseplate] Invalid location for dependency: " .. t .. " from " .. depend)
		end
	end

	Bricks.corebricks[nm] = cb.Init(Bricks)
end
for nm, mb in pairs(Bricks.modularbricks) do
	if mb.CLIENT_ONLY == mb.SERVER_ONLY then
		--It should be false
		if mb.CLIENT_ONLY ~= false then
			error("[Contribengine/baseplate] Brick cannot be client only and server only at the same time")
		end
	else
		if mb.CLIENT_ONLY == true then
			if clientSided == false then
				continue
			end
		elseif mb.SERVER_ONLY == true then
			if clientSided == true then
				continue
			end
		end
	end

	--Check dependencies
	for _, depend in pairs(mb.DEPENDENCIES) do
		local deptable = depend:split("/")

		local t = deptable[1]
		local dependency = deptable[2]

		if Bricks[t .. "bricks"] then
			if not Bricks[t .. "bricks"][dependency] then
				error("[Contribengine/baseplate] Missing dependency: " .. depend)
			end
		else
			error("[Contribengine/baseplate] Invalid location for dependency: " .. t .. " from " .. depend)
		end
	end

	Bricks.modularbricks[nm] = mb.Init(Bricks)
end

-- Return the Bricks so scripts outside of the brick structure can use them.
return Bricks
