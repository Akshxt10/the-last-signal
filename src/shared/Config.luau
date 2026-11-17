--!strict

--[[
	Central game settings, available to both server and client.
	Change values here instead of hunting through scripts.
]]

local Config = {
	GAME_NAME = "THE LAST SIGNAL",

	CAMERA = table.freeze({
		-- "FirstPerson" or "ThirdPerson"
		DEFAULT_MODE = "FirstPerson",
		-- Key that switches between the two modes (keyboard players)
		TOGGLE_KEY = Enum.KeyCode.V,
		-- Fixed camera distance in third person (studs)
		THIRD_PERSON_ZOOM = 12,
	}),
}

return table.freeze(Config)
