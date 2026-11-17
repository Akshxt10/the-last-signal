# Architecture

## Folder mapping
Rojo maps `src/` into the game as defined in `default.project.json`.

| Folder | In Roblox | Runs on | Purpose |
| --- | --- | --- | --- |
| `src/server` | `ServerScriptService.Server` | Server | Game logic, creatures |
| `src/client` | `StarterPlayer.StarterPlayerScripts.Client` | Each player's device | Camera, input, UI |
| `src/shared` | `ReplicatedStorage.Shared` | Both | Config and shared modules |

Each side has exactly one Script (`Main.server.luau`, `Main.client.luau`). Everything else is a ModuleScript that `Main` starts.

## Rules
1. **The server decides, the client displays.** Anything that affects gameplay (creature behaviour, damage, round state) runs on the server. The client handles camera, input and visuals.
2. **One module, one job.** Services (server) and Controllers (client) each own one area.
3. **Settings go in `Config`.** No magic numbers scattered through scripts.
4. **Never assume the player count.** Ask `PlayerService` (`isSolo()`, `getPlayerCount()`). Creature difficulty and spawn counts should scale from it.
5. **Use `--!strict`** at the top of every Luau file.
6. **Naming:** modules and types in `PascalCase`, functions and variables in `camelCase`, config constants in `UPPER_SNAKE_CASE`.
7. **Add networking only when needed.** When the client and server first need to talk, add one shared module that owns all RemoteEvents, rather than creating them in many places.
8. **Client code waits for shared content.** Client scripts get `ReplicatedStorage.Shared` with `WaitForChild` before requiring from it, because it may not have replicated yet.

## Camera
`CameraController` (client) supports `FirstPerson` and `ThirdPerson`. Keyboard players toggle with the key in `Config.CAMERA.TOGGLE_KEY`. Touch controls for switching are not built yet.

## Creatures
Creatures are data-driven so adding one never means editing core code.

- `src/server/Creatures/Types.luau` defines the `CreatureDefinition` type.
- Each creature is one ModuleScript in `src/server/Creatures/Definitions/`.
- `CreatureService` loads every definition on start and spawns them with `CreatureService.spawn(name, cframe)`.
- A definition that is invalid (not a table, missing `name` or `modelName`, or fails to load) is skipped with a warning in the Output window. It does not stop the server.
- Creature models are built in Studio and stored in `ServerStorage > CreatureModels`. Create that folder in Studio's Explorer. It is separate from `src/server/Creatures`, which holds code only.

Example definition, saved as `src/server/Creatures/Definitions/Stalker.luau`:

```lua
--!strict

local Types = require(script.Parent.Parent.Types)

local Stalker: Types.CreatureDefinition = {
	name = "Stalker",
	modelName = "Stalker",
	onSpawn = function(model)
		-- this creature's behaviour goes here
	end,
}

return Stalker
```

When a creature's behaviour grows large, move it into its own module next to the definition and call it from `onSpawn`.

## Studio-built assets
Maps, models, sounds and UI built in Studio live in the place file, which is not stored in Git. Code and design decisions live in this repository.
