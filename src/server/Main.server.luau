--!strict

--[[
	Server entry point. This is the only server Script.
	Everything else is a ModuleScript that gets started from here.
]]

local CreatureService = require(script.Parent.Services.CreatureService)

CreatureService.start()
