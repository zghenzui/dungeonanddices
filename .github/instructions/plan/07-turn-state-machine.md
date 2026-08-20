# Step 7: Turn State Machine

## Goal

Connect the domain rules through an explicit state machine that controls one complete Warrior turn.

## States

```text
START
PLAYER_MOVEMENT
PLAYER_ATTACK
ENEMY_ATTACK
SECOND_ATTACK
VICTORY
GAME_OVER
```

## Transition Rules

1. `START` enters `PLAYER_MOVEMENT`.
2. `PLAYER_MOVEMENT` rolls 2d6 once and permits legal movement.
3. After movement, the state checks Manhattan reachability.
4. If the Goblin is not reachable, the turn ends and returns to `PLAYER_MOVEMENT`.
5. If reachable, transition to `PLAYER_ATTACK`.
6. A surviving Goblin transitions to `ENEMY_ATTACK`.
7. A Goblin roll below 5 transitions to `SECOND_ATTACK`.
8. A Goblin roll of 5 or 6 ends the turn.
9. Any Warrior HP at or below zero enters `GAME_OVER`.
10. Any Goblin HP at or below zero spawns the Chest and enters `VICTORY`.

## Implementation Tasks

1. Define states as an enum or equivalent explicit values.
2. Give `Game` ownership of the current state and transition method.
3. Keep each transition guarded by current state and relevant entity status.
4. Store the latest movement, attack, and enemy-roll results for presentation.
5. Ensure terminal states reject further actions.

## Acceptance Criteria

- The current state is inspectable at all times.
- An action invalid for the current state is rejected without changing state.
- A successful first attack reaches victory if the Goblin dies.
- A surviving Goblin attacks exactly once before the second-strike decision.
- Goblin rolls 1..4 allow `SECOND_ATTACK`; rolls 5..6 end the turn.
- `GAME_OVER` and `VICTORY` are terminal.
- No transition depends on a visual callback chain.

## Definition Of Done

- [ ] Every listed state exists.
- [ ] All legal transitions are explicit and readable.
- [ ] Terminal states disable gameplay actions.
- [ ] Roll and attack results remain available to the UI.
- [ ] A complete turn can be simulated without rendering.

## Validation

Simulate paths for unreachable movement, victory on first attack, Warrior death, Goblin roll 1, Goblin roll 4, and Goblin roll 5. Assert each state sequence.
