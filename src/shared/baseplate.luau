--[[
-- Copyright Solivis Collective (C) 2025
-- baseplate.luau
--]]

local main = script.Parent

local Bricks = {
	corebricks = {},
	modularbricks = {},
}

-- Create the connections
---- Loop through the core bricks.
for _, corebrick in pairs(main.core:GetChildren()) do
	-- Require the bricks
	local required_brick = require(corebrick)

	--Put it into the table
	if required_brick.Init then
		Bricks.corebricks[corebrick.Name] = required_brick
	else
		error('Brick "' .. corebrick.Name .. '" must contain the "Init()" function.')
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
		error('Brick "' .. modularbrick.Name .. '" must contain the "Init()" function.')
	end
end
----Then, we need to go through each one, initialize it and reregister it.
for nm, cb in pairs(Bricks.corebricks) do
	Bricks.corebricks[nm] = cb.Init()
end
for nm, mb in pairs(Bricks.modularbricks) do
	Bricks.modularbricks[nm] = mb.Init()
end

-- Return the Bricks so scripts outside of the brick structure can use them.
return Bricks
