--!strict

--[[
	Client entry point. This is the only client Script.
	Everything else is a ModuleScript that gets started from here.
]]

local CameraController = require(script.Parent.Controllers.CameraController)

CameraController.start()
