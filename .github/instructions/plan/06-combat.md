# Step 6: Combat

## Goal

Resolve the Warrior's attack and the Goblin's counterattack as domain operations that return structured results.

## Rules

### Warrior attack

- Roll exactly 2d6.
- Damage is the dice total.
- If both dice match, add 2 critical bonus damage.
- Apply damage to the Goblin.

### Goblin attack

- Roll exactly 1d6.
- Damage is the die result.
- Apply damage to the Warrior.

The caller decides which attack is legal based on game state. Combat code must not update UI directly.

## Suggested Types

`CombatSession` owns the active attacker and defender. `AttackResult` contains:

- attacker
- defender
- dice results
- base damage
- critical flag
- final damage
- target HP after damage
- target died

## Implementation Tasks

1. Create attack resolution for the Warrior.
2. Apply the critical bonus only to Warrior 2d6 attacks.
3. Create Goblin 1d6 attack resolution.
4. Return immutable or completed result data for presentation and tests.
5. Ensure damage is clamped through the entity health invariant.

## Acceptance Criteria

- A Warrior roll of 4 + 3 deals 7 damage.
- A Warrior roll of 2 + 2 deals 6 damage and is marked critical.
- A Goblin roll of 4 deals 4 damage and is never marked as a Warrior critical.
- A dead Goblin cannot counterattack.
- An attack result describes the roll and outcome without requiring a scene tree.

## Definition Of Done

- [ ] `CombatSession` and attack result data have clear responsibilities.
- [ ] Critical calculation is implemented exactly once.
- [ ] Both combatants use the shared entity health rules.
- [ ] No nested callback chain controls the complete turn yet.

## Validation

Run fixed attack cases for normal damage, critical damage, overkill, and a dead target. Verify the result fields and final HP.
