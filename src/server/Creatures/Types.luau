--!strict

--[[
	Shared type for creature definitions. Every file in
	src/server/Creatures/Definitions returns a table of this shape.
]]

export type CreatureDefinition = {
	-- Unique creature name, used with CreatureService.spawn(name, cframe)
	name: string,
	-- Name of the model inside ServerStorage > CreatureModels
	modelName: string,
	-- Called once right after the creature spawns. Put its behaviour here.
	onSpawn: ((model: Model) -> ())?,
}

return {}
