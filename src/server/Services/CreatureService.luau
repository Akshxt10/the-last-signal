--!strict

--[[
	Creates and tracks creatures.

	Each creature is described by a definition module in
	src/server/Creatures/Definitions. On start, every definition is loaded and
	registered automatically. Adding a new creature never requires editing this file.

	Creature models are built in Roblox Studio and stored in
	ServerStorage > Creatures. A definition points to its model by name.
]]

local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local Types = require(script.Parent.Parent.Creatures.Types)

type CreatureDefinition = Types.CreatureDefinition

local CreatureService = {}

local definitions: { [string]: CreatureDefinition } = {}
local activeCreatures: { [Model]: CreatureDefinition } = {}

function CreatureService.register(definition: CreatureDefinition)
	if definitions[definition.name] then
		warn(`[CreatureService] "{definition.name}" is already registered`)
		return
	end
	definitions[definition.name] = definition
end

function CreatureService.spawn(name: string, spawnCFrame: CFrame): Model?
	local definition = definitions[name]
	if not definition then
		warn(`[CreatureService] Unknown creature "{name}"`)
		return nil
	end

	local modelsFolder = ServerStorage:FindFirstChild("Creatures")
	local template = if modelsFolder then modelsFolder:FindFirstChild(definition.modelName) else nil
	if not template or not template:IsA("Model") then
		warn(`[CreatureService] Model "{definition.modelName}" not found in ServerStorage.Creatures`)
		return nil
	end

	local model = template:Clone() :: Model
	model:PivotTo(spawnCFrame)
	model.Parent = Workspace

	activeCreatures[model] = definition
	model.Destroying:Connect(function()
		activeCreatures[model] = nil
	end)

	if definition.onSpawn then
		task.spawn(definition.onSpawn, model)
	end

	return model
end

function CreatureService.getActiveCreatures(): { Model }
	local list: { Model } = {}
	for model in activeCreatures do
		table.insert(list, model)
	end
	return list
end

function CreatureService.start()
	local definitionsFolder = script.Parent.Parent.Creatures.Definitions

	for _, child in definitionsFolder:GetChildren() do
		if child:IsA("ModuleScript") then
			local ok, definition = pcall(require, child)
			if ok then
				CreatureService.register(definition)
			else
				warn(`[CreatureService] Failed to load {child.Name}: {definition}`)
			end
		end
	end
end

return CreatureService
