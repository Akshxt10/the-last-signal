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
4. Create a place file from the project (first time only):
   ```
   rojo build -o the-last-signal.rbxl
   ```
   Open it in Studio.
5. Start syncing: `rojo serve`, then click **Connect** in the Rojo plugin inside Studio.

Code lives in `src/` and is edited as text. Maps, models and other Studio-built assets live in the place file. Place files (`*.rbxl`) are not committed, so save the place to Roblox from Studio to keep it backed up.

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
