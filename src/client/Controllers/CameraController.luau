--!strict

--[[
	First-person / third-person camera.

	Keyboard players switch with the key set in Config.CAMERA.TOGGLE_KEY.
	Other systems can call CameraController.setMode("FirstPerson" | "ThirdPerson").
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage.Shared.Config)

export type CameraMode = "FirstPerson" | "ThirdPerson"

local FIRST_PERSON_ZOOM = 0.5

local CameraController = {}

local player = Players.LocalPlayer
local currentMode: CameraMode = "FirstPerson"

function CameraController.getMode(): CameraMode
	return currentMode
end

function CameraController.setMode(mode: CameraMode)
	currentMode = mode

	if mode == "FirstPerson" then
		player.CameraMinZoomDistance = FIRST_PERSON_ZOOM
		player.CameraMaxZoomDistance = FIRST_PERSON_ZOOM
		player.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		player.CameraMaxZoomDistance = Config.CAMERA.THIRD_PERSON_ZOOM
		player.CameraMinZoomDistance = Config.CAMERA.THIRD_PERSON_ZOOM
		player.CameraMode = Enum.CameraMode.Classic
	end
end

function CameraController.toggle()
	if currentMode == "FirstPerson" then
		CameraController.setMode("ThirdPerson")
	else
		CameraController.setMode("FirstPerson")
	end
end

function CameraController.start()
	if Config.CAMERA.DEFAULT_MODE == "ThirdPerson" then
		CameraController.setMode("ThirdPerson")
	else
		CameraController.setMode("FirstPerson")
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.KeyCode == Config.CAMERA.TOGGLE_KEY then
			CameraController.toggle()
		end
	end)
end

return CameraController
