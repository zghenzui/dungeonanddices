# Step 8: Victory And Game Over

## Goal

Complete the prototype loop by handling Warrior death and Goblin defeat as terminal outcomes.

## Rules

### Game over

- If Warrior HP is less than or equal to zero, transition to `GAME_OVER`.
- Display `GAME OVER`.
- Reject movement, attacks, and rolls after the transition.

### Victory

- If Goblin HP is less than or equal to zero, remove the Goblin from the board.
- Spawn a Chest at the configured Chest spawn tile.
- Transition to `VICTORY`.
- Display `DUNGEON CLEARED`.
- Reject further gameplay actions.

If both combatants would reach zero from one operation, resolve the Goblin defeat or Warrior death according to the current attack rule and document the chosen precedence in tests.

## Implementation Tasks

1. Add outcome evaluation after every damage application.
2. Remove dead Goblin presentation from the board.
3. Place the Chest only after a valid victory.
4. Add terminal-state UI messages.
5. Make all action handlers no-ops or explicit errors in terminal states.

## Acceptance Criteria

- Warrior HP 0 produces `GAME OVER` and no further rolls are possible.
- Goblin HP 0 removes the Goblin and creates exactly one Chest.
- Victory displays `DUNGEON CLEARED`.
- The Chest appears at the configured spawn location.
- Repeated clicks or commands after either terminal result cannot change entities or state.
- Terminal results are reproducible with fixed dice.

## Definition Of Done

- [ ] Both terminal states are reachable through normal gameplay.
- [ ] Board contents match the outcome.
- [ ] Terminal messages are visible.
- [ ] Terminal actions are blocked.
- [ ] Outcome precedence is covered by a test.

## Validation

Force one Warrior death and one Goblin death using controlled combat results. Verify state, HP, board entities, message, and action lockout after each scenario.
