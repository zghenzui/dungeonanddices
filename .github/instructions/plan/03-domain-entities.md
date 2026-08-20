# Step 3: Domain Entities

## Goal

Introduce the smallest object-oriented domain model for the Warrior, Goblin, Chest, and shared entity state.

## Scope

Create plain GDScript classes for:

- `Entity`: identifier, board position, and alive state.
- `Hero`: common hero health and ability data.
- `Warrior`: 5 maximum HP and the first playable hero.
- `Enemy`: common enemy health and attack configuration.
- `Goblin`: 10 maximum HP and one d6 attack.
- `Chest`: a placed reward entity with no progression behavior.

Keep these classes independent from scene nodes and UI. Do not add speculative interfaces, factories, or ability hierarchies.

## Implementation Tasks

1. Define constructors and default values for each domain class.
2. Keep position as grid coordinates compatible with `Board`.
3. Add health damage and alive-state behavior where needed.
4. Prevent health from exceeding maximum or dropping below zero.
5. Create temporary scene adapters only where the board view needs to display an entity.

## Acceptance Criteria

- A new Warrior starts at 5/5 HP and is alive.
- A new Goblin starts at 10/10 HP and is alive.
- Applying damage reduces HP and marks an entity dead at zero.
- Dead entities cannot be damaged into negative HP or treated as alive.
- Domain classes can be instantiated without a running scene tree.

## Definition Of Done

- [ ] Shared entity state is not duplicated across Warrior and Goblin.
- [ ] Health invariants are enforced in domain code.
- [ ] Presentation code reads domain state instead of owning it.
- [ ] No combat turn flow has been implemented yet.

## Validation

Instantiate each class in a lightweight script or test and verify default values, position assignment, damage, and death behavior.
