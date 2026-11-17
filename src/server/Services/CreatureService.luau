--!strict

--[[
	Creates and tracks creatures.

	Each creature is described by a definition module in
	src/server/Creatures/Definitions. On start, every definition is loaded and
	registered automatically. Adding a new creature never requires editing this file.
	Invalid definitions are skipped with a warning instead of stopping the server.

	Creature models are built in Roblox Studio and stored in
	ServerStorage > CreatureModels. A definition points to its model by name.
]]

local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local Types = require(script.Parent.Parent.Creatures.Types)

type CreatureDefinition = Types.CreatureDefinition

local MODELS_FOLDER_NAME = "CreatureModels"

local CreatureService = {}

local definitions: { [string]: CreatureDefinition } = {}
local activeCreatures: { [Model]: CreatureDefinition } = {}

-- Returns a description of what is wrong with a definition, or nil if it is valid.
local function getDefinitionProblem(value: any): string?
	if type(value) ~= "table" then
		return "module must return a table"
	end
	if type(value.name) ~= "string" or value.name == "" then
		return "`name` must be a non-empty string"
	end
	if type(value.modelName) ~= "string" or value.modelName == "" then
		return "`modelName` must be a non-empty string"
	end
	if value.onSpawn ~= nil and type(value.onSpawn) ~= "function" then
		return "`onSpawn` must be a function if provided"
	end
	return nil
end

-- Returns true if the definition was registered, false if it was skipped.
function CreatureService.register(definition: CreatureDefinition, source: string?): boolean
	local problem = getDefinitionProblem(definition)
	if problem then
		warn(
			`[CreatureService] Skipping invalid creature definition ({source or "unknown source"}): {problem}`
		)
		return false
	end

	if definitions[definition.name] then
		warn(`[CreatureService] "{definition.name}" is already registered, skipping`)
		return false
	end

	definitions[definition.name] = definition
	return true
end

function CreatureService.spawn(name: string, spawnCFrame: CFrame): Model?
	local definition = definitions[name]
	if not definition then
		warn(`[CreatureService] Unknown creature "{name}"`)
		return nil
	end

	local modelsFolder = ServerStorage:FindFirstChild(MODELS_FOLDER_NAME)
	local template = if modelsFolder then modelsFolder:FindFirstChild(definition.modelName) else nil
	if not template or not template:IsA("Model") then
		warn(
			`[CreatureService] Model "{definition.modelName}" not found in ServerStorage.{MODELS_FOLDER_NAME}`
		)
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
	local definitionsFolder = script.Parent.Parent.Creatures:FindFirstChild("Definitions")
	if not definitionsFolder then
		warn("[CreatureService] Definitions folder not found, no creatures were loaded")
		return
	end

	for _, child in definitionsFolder:GetChildren() do
		if child:IsA("ModuleScript") then
			local ok, result = pcall(require, child)
			if ok then
				CreatureService.register(result, child.Name)
			else
				warn(`[CreatureService] Failed to load definition "{child.Name}": {result}`)
			end
		end
	end
end

return CreatureService
