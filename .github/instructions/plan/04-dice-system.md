# Step 4: Dice System

## Goal

Implement reusable domain dice objects for six-sided movement, attack, and Goblin rolls.

## Scope

- `Die(sides)` with a valid side count and a roll operation.
- `DiceRoll` containing die results, total, and whether the results are matching.
- A two-d6 roll for movement.
- A two-d6 roll for Warrior attacks.
- A one-d6 roll for Goblin attacks.
- Optional injected random source or seed support for deterministic tests.

Do not add animations, sounds, rerolls, modifiers, advantage, or disadvantage yet.

## Rules

- A d6 result is an integer from 1 through 6.
- `DiceRoll.total` is the sum of all results.
- A two-die roll is critical when both results are equal.
- Critical detection is data on the roll; the critical damage bonus belongs to combat resolution.

## Implementation Tasks

1. Validate dice sides before rolling.
2. Keep raw results in their original order for presentation and tests.
3. Expose total and matching-result information without coupling to UI.
4. Provide a test seam for fixed rolls.
5. Ensure every gameplay roll is created through the dice domain API.

## Acceptance Criteria

- Every d6 result is within 1..6.
- A 2d6 roll exposes two results and their sum.
- `[2, 2]` is marked critical; `[2, 3]` is not.
- A 1d6 Goblin roll is not treated as a critical attack roll.
- Fixed test results can reproduce movement and attack outcomes.

## Definition Of Done

- [ ] `Die` and `DiceRoll` are independent of Godot visual nodes.
- [ ] Movement, attack, and enemy roll shapes are supported.
- [ ] Randomness can be controlled in tests.
- [ ] No damage or turn transitions are hidden in the dice classes.

## Validation

Run repeated d6 rolls and assert the range. Run fixed `[2, 2]`, `[2, 3]`, and single-value examples and verify total and critical fields.
