# Step 2: Fixed Dungeon Board

## Goal

Render and model a fixed 12 x 8 tile dungeon board that can hold the Warrior, Goblin, and future Chest.

## Scope

- Create a `Board` domain object and a `Tile` value/object model.
- Represent valid grid coordinates from `(0, 0)` through `(11, 7)`.
- Render floor tiles in a stable desktop layout.
- Place the Warrior, Goblin, and reserved Chest spawn location.
- Support empty tiles and optional static obstacles.

Do not add procedural generation, movement input, combat, inventory, or dungeon progression.

## Implementation Tasks

1. Define board dimensions as constants or configuration owned by `Board`.
2. Add tile validity, occupancy, and coordinate lookup methods.
3. Create a fixed board layout with deterministic starting positions.
4. Add a `BoardView` that renders the grid without owning gameplay rules.
5. Render entities as temporary colored shapes or labels.
6. Confirm the board remains correctly aligned when the window is resized.

## Acceptance Criteria

- The game displays exactly 12 columns and 8 rows of valid floor tiles.
- The Warrior and Goblin appear on distinct, valid tiles.
- The Chest spawn tile is known even before a Chest exists.
- Invalid coordinates cannot be occupied or returned as valid movement destinations.
- Visual nodes display board state but do not calculate game rules.

## Definition Of Done

- [ ] `Board` and `Tile` exist with clear responsibilities.
- [ ] Fixed layout renders consistently.
- [ ] Entity placement is deterministic.
- [ ] Occupancy checks are testable without rendering the scene.
- [ ] No procedural generation or gameplay behavior was added.

## Validation

Run the project and inspect all four board edges and both entity positions. Test at least one invalid coordinate and one occupied coordinate through the board API.
