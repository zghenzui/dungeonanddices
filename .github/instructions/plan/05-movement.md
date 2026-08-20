# Step 5: Movement

## Goal

Let the player roll 2d6 once at the beginning of a turn and move the Warrior up to the resulting number of tiles.

## Rules

- Movement allowance is the total of exactly two d6 results.
- The roll occurs once per player movement phase.
- Movement uses orthogonal grid steps only.
- Manhattan distance is used for reachability: `abs(dx) + abs(dy)`.
- The Warrior cannot leave the board, occupy an occupied tile, or exceed the allowance.
- If obstacles are present, the movement path must not pass through them.

## Implementation Tasks

1. Add a movement result containing dice results and allowance.
2. Add board methods for valid destinations and Manhattan distance.
3. Track remaining movement for the current turn.
4. Allow the presentation layer to select or move the Warrior through legal destinations.
5. After movement ends, report whether the Goblin is reachable with the remaining movement.

Do not add diagonal movement, pathfinding, procedural obstacles, or a second movement roll during the same turn.

## Acceptance Criteria

- A movement phase rolls two d6 and displays their total.
- The Warrior can move zero through the allowance number of tiles.
- Invalid, occupied, and blocked destinations are rejected.
- Manhattan distance is consistent for both reachability and tests.
- The movement roll cannot be repeated until a new player turn begins.
- A Warrior adjacent to the Goblin can engage; a Warrior beyond the allowance cannot.

## Definition Of Done

- [ ] Movement rules are domain-testable without UI.
- [ ] Board occupancy remains authoritative.
- [ ] Movement allowance is visible to the player.
- [ ] The next state can use the reachability result to begin combat or end the turn.

## Validation

Use fixed dice results such as 3 + 4 = 7. Test edge tiles, occupied tiles, blocked paths, exact-distance reachability, and a distance greater than the allowance.
