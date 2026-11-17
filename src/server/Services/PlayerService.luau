--!strict

--[[
	Small helpers for answering "who is playing?".

	The game must work for 1 player (solo) and for several (co-op), so
	other systems should ask this module instead of assuming a player count.
]]

local Players = game:GetService("Players")

local PlayerService = {}

function PlayerService.getPlayers(): { Player }
	return Players:GetPlayers()
end

function PlayerService.getPlayerCount(): number
	return #Players:GetPlayers()
end

function PlayerService.isSolo(): boolean
	return PlayerService.getPlayerCount() <= 1
end

return PlayerService
