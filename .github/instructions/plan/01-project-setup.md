# Step 1: Project Setup

## Goal

Create the smallest runnable Dice Dungeon project in Godot 4.x using GDScript. At the end of this step, the project should open and run as a desktop application with an empty prototype scene.

## Scope

### Included

- Create a Godot 4.x project.
- Use GDScript as the project scripting language.
- Configure the project for a desktop window.
- Create a main scene that launches successfully.
- Establish folders for domain logic, presentation, scenes, tests, and plan documentation.
- Add a minimal placeholder screen identifying the project as Dice Dungeon.

### Excluded

- Gameplay rules.
- Player, enemy, dice, board, or combat implementation.
- Online multiplayer, accounts, databases, matchmaking, Steam integration, and persistent progression.
- External art, sound, or third-party plugins.

## Recommended Project Structure

```text
dungeonanddices/
├── project.godot
├── scenes/
├── scripts/
│   ├── domain/
│   ├── presentation/
│   └── game/
├── tests/
├── assets/
│   ├── art/
│   ├── audio/
│   └── fonts/
└── .github/
	└── instructions/
		└── plan/
```

Keep domain classes in `scripts/domain/` and Godot `Node`-based presentation scripts in `scripts/presentation/`. Do not create a class or abstraction until a later step needs it.

## Implementation Tasks

1. Create a Godot 4.x project in the repository root.
2. Set the main scene to a simple `Node2D` or `Control` scene.
3. Add a visible `Dice Dungeon` title and a temporary `Prototype Setup Complete` label.
4. Configure a reasonable desktop window size and stretch behavior.
5. Create the project folders listed above where they do not already exist.
6. Confirm the project runs without network services or external dependencies.

## Acceptance Criteria

Given a fresh checkout of the repository,

- When the project is opened in Godot 4.x,
- Then the project imports without errors.
- When the project is run,
- Then the main scene opens in a desktop window.
- When the main scene is displayed,
- Then `Dice Dungeon` and `Prototype Setup Complete` are visible.
- When the project files are inspected,
- Then no multiplayer, account, database, matchmaking, Steam, or persistence system exists.

## Definition Of Done

- [ ] Godot project opens without import errors.
- [ ] Main scene is configured and launches successfully.
- [ ] Placeholder screen is visible at runtime.
- [ ] Project folders are present and named consistently.
- [ ] No gameplay functionality has been added prematurely.
- [ ] The next step can add the fixed board without restructuring this setup.

## Validation

Run the project from the Godot editor and verify the placeholder screen appears. Stop here if the project does not launch cleanly; later gameplay work should not begin until this baseline is reliable.
