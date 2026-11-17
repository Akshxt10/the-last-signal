# the-last-signal
A cooperative survival horror game developed for Roblox.

## Status
Early setup. The project structure, tooling and core bootstrap are in place; gameplay is not built yet. See [docs/ROADMAP.md](docs/ROADMAP.md).

## Tech
- Roblox, written in Luau
- [Rojo](https://rojo.space) syncs the files in `src/` into Roblox Studio
- Tool versions are pinned in `rokit.toml` (Rojo, StyLua, Selene)

## Project layout
```
src/
  server/   -> ServerScriptService.Server       (game logic, creatures)
  client/   -> StarterPlayerScripts.Client      (camera, input, UI)
  shared/   -> ReplicatedStorage.Shared         (config, shared modules)
docs/       Game design, architecture, roadmap
```
Details are in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Getting started (Windows laptop with Roblox Studio)
1. Install [Git](https://git-scm.com) and [Rokit](https://github.com/rojo-rbx/rokit).
2. Clone and install tools:
   ```
   git clone https://github.com/Akshxt10/the-last-signal.git
   cd the-last-signal
   rokit install
   ```
3. Install the Rojo plugin into Studio: `rojo plugin install`
4. Build a place file from the project (first time only):
   ```
   rojo build -o the-last-signal.rbxl
   ```
   Open `the-last-signal.rbxl` in Studio.
5. **Add a Baseplate and a SpawnLocation.** The built place contains only the scripts, so it has no ground and no spawn point. If you skip this, your character falls into the void when you press Play. In Studio:
   1. Open the **Explorer** window (View tab > Explorer) if it is not visible.
   2. Hover over **Workspace**, click the **+** button and choose **Part**.
   3. Select the new Part. In the **Properties** window set: Name `Baseplate`, Size `512, 4, 512`, Position `0, -2, 0`, and make sure **Anchored** is ticked.
   4. Hover over **Workspace** again, click **+** and choose **SpawnLocation**.
   5. Select the SpawnLocation, set Position to `0, 0.5, 0`, and make sure **Anchored** is ticked.
   6. Save the place: File > Save to Roblox (or Save to File As... for a local copy).

   These objects live in the place file, not in Git. Rojo will not remove them, because the project file does not manage Workspace. Do not run `rojo build` again unless you want a fresh empty place; keep working in the place you saved.
6. Start syncing: run `rojo serve`, then click **Connect** in the Rojo plugin inside Studio.
7. Press Play in Studio to test.

Code lives in `src/` and is edited as text. Maps, models and other Studio-built assets live in the place file. Place files (`*.rbxl`) are not committed, so save the place to Roblox from Studio to keep it backed up.

## Creature models
Creature behaviour is code in `src/server/Creatures/Definitions/`. Creature models are built in Studio and kept in a folder named `CreatureModels` inside **ServerStorage** (create it in Explorer). See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Code quality
```
stylua src      # format
selene src      # lint (run `selene generate-roblox-std` once first)
```

## Working on iPhone
Code and docs can be edited as text and committed to GitHub from a phone. Studio and Rojo need the Windows laptop, so anything that needs testing in-game waits until then.

## Git workflow
- `main` stays stable.
- Do work on a branch (for example `feature/first-creature`) and merge through a pull request after review.
