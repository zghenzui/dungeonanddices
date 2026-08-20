# Step 9: Prototype UI

## Goal

Expose the playable loop clearly through a simple desktop UI that reflects domain state and guides the next legal action.

## Layout

- Top status area: Warrior HP and Goblin HP.
- Center area: fixed dungeon board and entity views.
- Bottom action area: current action button and latest dice results.
- Outcome area: `GAME OVER` or `DUNGEON CLEARED` when terminal.

## Action Labels

The primary action should reflect the current state:

- `ROLL MOVEMENT`
- `MOVE`
- `ROLL ATTACK`
- `ROLL ENEMY`
- `ROLL ATTACK AGAIN`

Disable or hide the action after `VICTORY` and `GAME_OVER`.

## Implementation Tasks

1. Create `BoardView`, `HeroView`, `GoblinView`, and `CombatUI` or equivalent focused views.
2. Bind status labels to current domain state.
3. Show each dice result and the computed total.
4. Route button commands to the state machine, never directly to entity mutation.
5. Refresh views after a completed domain result.
6. Use placeholder shapes and text before adding art assets.

## Acceptance Criteria

- The player can identify the current state and legal next action.
- Warrior and Goblin HP always match domain values.
- Movement and attack dice results remain visible after rolling.
- The board updates after movement, Goblin death, and Chest spawn.
- Invalid actions are disabled or rejected visibly.
- UI code does not calculate damage, criticals, distance, or turn transitions.

## Definition Of Done

- [ ] Desktop layout is readable at the configured window size.
- [ ] State-specific action labels work.
- [ ] Dice values and totals are visible.
- [ ] Terminal messages are prominent and unambiguous.
- [ ] Presentation remains replaceable without changing domain rules.

## Validation

Play through movement, first attack, counterattack, second strike, victory, and game over. At every step compare the displayed state and action with the state machine.
