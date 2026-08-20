# Step 10: Testing

## Goal

Protect the dice rules, board invariants, combat outcomes, and state transitions with fast offline tests.

## Test Layers

### Domain tests

- Entity default HP and alive state.
- Damage clamping and death.
- Board bounds, occupancy, and Manhattan distance.
- d6 ranges, totals, and critical detection.
- Warrior critical damage and Goblin damage.

### State-flow tests

- Start to movement.
- Unreachable Goblin ends the turn.
- Reachable Goblin enters attack.
- Surviving Goblin counterattacks.
- Goblin roll 1..4 enables second attack.
- Goblin roll 5..6 ends the turn.
- Victory and game over are terminal.

### Minimal presentation check

Verify the main scene launches and key labels exist. Do not make visual animation tests a prerequisite for the first playable prototype.

## Implementation Tasks

1. Add a test runner or lightweight Godot test setup appropriate for the project.
2. Inject fixed dice results into domain tests.
3. Keep tests independent of timing, rendering, and external services.
4. Add one complete deterministic turn scenario.
5. Run tests before and after rule changes.

## Acceptance Criteria

- Tests fail when critical damage changes from the specified rule.
- Tests detect illegal board positions and occupied destinations.
- Tests distinguish Goblin rolls below 5 from rolls 5 or higher.
- Tests prove terminal states reject further actions.
- The full test suite runs offline and completes quickly.

## Definition Of Done

- [ ] Core domain invariants have direct tests.
- [ ] Every state transition branch has coverage.
- [ ] At least one victory and one game-over scenario are deterministic.
- [ ] Tests do not require multiplayer, accounts, databases, or network services.

## Validation

Run the complete test suite from the editor or command line. Record any framework-specific test command in the project documentation once the Godot project exists.
