# Dice Dungeon — Prototype Specification

## 1. Project Vision

Create a simple 2D desktop cooperative dungeon-crawler inspired by classic tabletop RPGs and board games.

The game should be:

- 2D
- Desktop-first
- Turn-based
- Dice-driven
- Designed for 2–4 player cooperative play eventually
- Developed completely offline first
- Built with object-oriented programming so the prototype can evolve into the full game

The first prototype must NOT implement online multiplayer, accounts, databases, matchmaking, Steam integration, or persistent progression.

The first goal is to prove that the core dice-based gameplay is fun.

---

## 2. Recommended Technology

### Engine

Use **Godot 4.x**.

### Language

Use **GDScript**.

### Prototype architecture

Use object-oriented domain classes for game entities and rules.

Avoid making every game object a Godot `Node`. Keep game logic separated from visual presentation where practical.

Example separation:

```text
GAME LOGIC                  VISUALS

Hero                        HeroView
Goblin                      GoblinView
Die                         DiceView
CombatSession               CombatUI
Board                       BoardView
```

This separation should make the game easier to test and later adapt for online multiplayer.

---

## 3. Core Game Concept

The game is a digital tabletop dungeon crawler.

The player controls a hero on a 2D dungeon board.

Movement and combat are determined by physical-looking dice rolls.

The dice are a central part of the game experience and should eventually be visually satisfying: rolling, bouncing, stopping, and clearly displaying their results.

For the initial prototype there is only one playable hero:

**Warrior**

There is only one enemy:

**Goblin**

There is only one reward:

**Chest**

---

# 4. Prototype Gameplay

## Player

The Warrior has:

- 5 hit points
- Movement ability
- Strike ability

## Goblin

The Goblin has:

- 10 hit points
- One attack

---

# 5. Board

The prototype should use a fixed dungeon board.

Recommended initial size:

**12 × 8 tiles**

The board should contain:

- Warrior
- Goblin
- Empty floor tiles
- Optional simple obstacles
- Chest spawn location

Do not implement procedural dungeon generation yet.

The Warrior moves between tiles.

---

# 6. Movement Rules

At the beginning of the Warrior's turn:

1. Throw two six-sided dice.
2. Add the values.
3. The resulting sum is the Warrior's movement allowance.
4. The Warrior can move up to that many tiles.

Example:

```text
Dice: 3 + 4
Movement: 7
```

The movement roll happens once per player turn.

---

# 7. Combat Trigger

After movement, determine whether the Warrior can reach/engage the Goblin using the movement result.

If the Warrior has enough movement to adjust/reach the enemy, combat begins.

The exact board-distance calculation should use the game's tile/grid distance consistently.

For the prototype, use a simple Manhattan/grid distance unless a better rule is explicitly introduced later.

---

# 8. Warrior Attack

When combat begins, the Warrior throws two six-sided dice.

The sum of the two dice is the attack damage.

Example:

```text
4 + 3 = 7 attack points
```

The Goblin loses 7 HP.

If the Goblin had 10 HP:

```text
10 - 7 = 3 HP
```

---

# 9. Critical Strike

If both attack dice show the same value, the attack is a critical strike.

Example:

```text
2 + 2
```

Normal damage:

```text
2 + 2 = 4
```

Critical bonus:

```text
+2
```

Total damage:

```text
6
```

Critical rule:

```text
if die_1 == die_2:
    damage = die_1 + die_2 + 2
else:
    damage = die_1 + die_2
```

The critical rule applies to the Warrior's attack rolls.

---

# 10. Goblin Counterattack

If the Goblin survives the Warrior's attack:

1. Goblin throws one six-sided die.
2. The result is the Goblin's attack damage.
3. The Warrior loses that many HP.

Example:

```text
Goblin roll: 4
Warrior HP: 5 → 1
```

---

# 11. Second Strike Rule

After the Goblin attacks:

- If the Goblin rolls **1, 2, 3, or 4**, the Warrior gets another strike opportunity.
- If the Goblin rolls **5 or 6**, the Warrior does not get a second strike.

Therefore:

```text
Goblin roll < 5 → second Warrior strike
Goblin roll >= 5 → end turn
```

The second strike uses the normal Warrior attack rules, including critical strikes.

---

# 12. Death and Victory

## Warrior death

If:

```text
Warrior HP <= 0
```

the game ends.

Display:

**GAME OVER**

No further actions can be performed.

## Goblin death

If:

```text
Goblin HP <= 0
```

the Goblin dies.

The Goblin is removed from the board.

A Chest appears.

Display:

**DUNGEON CLEARED**

The prototype ends at this point.

---

# 13. Complete Prototype State Flow

```text
START
  ↓
PLAYER_MOVEMENT
  ↓
ROLL 2D6
  ↓
MOVE WARRIOR
  ↓
CAN REACH ENEMY?
  ├── NO → END TURN
  │
  └── YES
       ↓
PLAYER_ATTACK
       ↓
ROLL 2D6
       ↓
CALCULATE DAMAGE
       ↓
CRITICAL?
       ↓
APPLY DAMAGE
       ↓
GOBLIN DEAD?
   ├── YES → SPAWN CHEST → VICTORY
   │
   └── NO
        ↓
ENEMY_ATTACK
        ↓
ROLL 1D6
        ↓
APPLY DAMAGE
        ↓
WARRIOR DEAD?
   ├── YES → GAME OVER
   │
   └── NO
        ↓
GOBLIN ROLL < 5?
   ├── YES → SECOND_PLAYER_ATTACK
   │           ↓
   │        ROLL 2D6
   │           ↓
   │        Resolve attack
   │
   └── NO → END TURN
```

The state machine should be explicit rather than relying on deeply nested callbacks.

---

# 14. Object-Oriented Domain Model

The initial domain model should remain small.

Recommended classes:

```text
Game
GameState
Board
Tile

Entity
Hero
Warrior

Enemy
Goblin

Chest

Die
DiceRoll

CombatSession
```

Additional classes such as `Ability`, `AttackResult`, `MovementResult`, etc. should only be introduced when they become necessary.

---

# 15. Entity

Create a common base class:

```text
Entity
```

Suggested responsibilities/data:

- id
- board position
- alive/dead state

Potential subclasses:

```text
Entity
├── Hero
├── Enemy
├── Chest
└── Obstacle
```

Do not put game-wide rules inside `Entity`.

---

# 16. Hero

Create:

```text
Hero
```

Suggested properties:

- max_hp
- hp
- position
- abilities

Then:

```text
Hero
└── Warrior
```

The Warrior is the first concrete playable hero.

Future classes:

```text
Hero
├── Warrior
├── Mage
├── Rogue
└── Priest
```

However, as the game grows, prefer composition/data-driven abilities instead of putting every class-specific behavior into subclasses.

---

# 17. Enemy

Create:

```text
Enemy
```

Suggested properties:

- max_hp
- hp
- position
- attack configuration

Then:

```text
Enemy
└── Goblin
```

Future enemies may include:

```text
Goblin
Orc
Skeleton
Dragon
...
```

---

# 18. Dice System

Dice are a fundamental game mechanic and should have dedicated classes.

Create:

```text
Die
```

Suggested properties:

- sides
- current value

Suggested behavior:

```text
roll()
```

Examples:

```text
Die(6)
Die(8)
Die(20)
```

Also create:

```text
DiceRoll
```

which represents a collection of rolled dice.

Suggested data:

- dice
- results
- total
- critical

Example:

```text
2d6
→ [2, 2]
→ total = 4
→ critical = true
```

The dice system should eventually support:

- different dice sizes
- multiple dice
- modifiers
- critical detection
- rerolls
- advantage/disadvantage if the game eventually needs them

Do not implement those future mechanics yet.

---

# 19. Combat System

Create:

```text
CombatSession
```

It should represent an active fight between entities.

Suggested data:

- attacker
- defender
- current state
- latest dice roll

Combat resolution should produce structured results rather than directly manipulating UI.

For example:

```text
AttackResult
- attacker
- defender
- dice_results
- damage
- critical
- target_died
```

This will make the combat rules easier to test and later synchronize over a network.

---

# 20. Board System

Create:

```text
Board
Tile
```

`Board` owns the playable area.

`Tile` represents an individual grid location.

The board should be responsible for questions such as:

- Is a tile valid?
- Is a tile occupied?
- Where is an entity?
- Can an entity move to a tile?

Movement rules should not be hardcoded into the visual character object.

---

# 21. Game State

Create an explicit game-state system.

Initial states:

```text
START
PLAYER_MOVEMENT
PLAYER_ATTACK
ENEMY_ATTACK
SECOND_ATTACK
VICTORY
GAME_OVER
```

`Game` controls transitions between these states.

This should make the rules easy to understand and later expand.

---

# 22. Visual Architecture

Keep game logic and visuals reasonably separated.

For example:

```text
Domain model:

Hero
Goblin
Board
Die
CombatSession

Godot presentation:

HeroView
GoblinView
BoardView
DiceView
CombatUI
```

A visual object should display the result of game logic rather than being the source of truth.

For example:

```text
CombatSession
    ↓
AttackResult
    ↓
CombatUI / DiceView / GoblinView
```

Not:

```text
GoblinSprite
    ↓
somehow decides combat rules
```

---

# 23. Prototype UI

The first UI should be simple.

Suggested layout:

```text
┌─────────────────────────────────────────────┐
│ Warrior HP 5/5            Goblin HP 10/10  │
├─────────────────────────────────────────────┤
│                                             │
│                 DUNGEON                     │
│                                             │
│             ⚔️               🧌             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│                 [ ROLL ]                    │
│                                             │
│             3 + 5 = 8                      │
│                                             │
└─────────────────────────────────────────────┘
```

The main action button should change based on the current game state.

Examples:

```text
ROLL MOVEMENT
MOVE
ROLL ATTACK
ROLL ENEMY
ROLL ATTACK AGAIN
```

---

# 24. Dice Presentation

For the first implementation, the dice may simply display their values.

Example:

```text
[ ROLL ]

🎲 3    🎲 5

MOVEMENT: 8
```

After the core mechanics are working, improve the dice presentation with:

- physical-looking rolling
- rotation
- bouncing
- shadows
- sound
- clear final values

The dice should eventually become one of the most satisfying parts of the game.

---

# 25. Development Strategy

Implement the prototype in small vertical slices.

### Story group 1 — Board

Create the Godot project and render a fixed dungeon board.

### Story group 2 — Warrior

Add the Warrior entity, position, and HP.

### Story group 3 — Goblin

Add the Goblin entity and HP.

### Story group 4 — Dice

Implement a six-sided die and two-dice rolls.

### Story group 5 — Movement

Implement movement rolls and tile-based Warrior movement.

### Story group 6 — Combat

Implement Warrior attacks and damage.

### Story group 7 — Critical hits

Implement matching-dice critical strikes with +2 damage.

### Story group 8 — Enemy attack

Implement Goblin's d6 attack.

### Story group 9 — Second strike

Implement the Goblin-roll-less-than-5 rule.

### Story group 10 — Victory

Remove dead Goblin and spawn Chest.

### Story group 11 — Game over

Handle Warrior death.

### Story group 12 — Presentation

Improve UI, dice visuals, animations, and sounds.

---

# 26. Spec-Driven Development Approach

Every future user story should be small enough to implement independently.

Each story should contain:

```text
## User Story

As a [player/developer],
I want [functionality],
so that [reason].

## Acceptance Criteria

Given ...
When ...
Then ...

## Technical Notes

Relevant classes:
- ...

Relevant game state:
- ...

Dependencies:
- ...

## Definition of Done

- [ ] Implementation complete
- [ ] Acceptance criteria pass
- [ ] No unrelated functionality added
- [ ] Existing prototype still works
```

Stories should describe observable behavior and acceptance criteria rather than prescribing unnecessary implementation details.

---

# 27. Important Development Rules

## Keep the prototype offline

Do NOT implement:

- online multiplayer
- networking
- dedicated servers
- accounts
- authentication
- matchmaking
- cloud saves
- databases
- Steam integration

until the offline core game is proven fun.

## Keep the first prototype small

Do NOT add:

- multiple heroes
- multiple dungeons
- inventory
- equipment
- procedural generation
- progression
- skill trees
- crafting
- quests
- NPCs
- shops

until the core loop works.

## Avoid premature architecture

Use OOP and clear separation of concerns, but don't create abstractions without a concrete need.

Prefer:

```text
simple class
```

over:

```text
five interfaces
three factories
two abstract managers
```

when the game only has one implementation.

---

# 28. Future Direction

After the offline prototype is fun, the likely expansion path is:

```text
Prototype
    ↓
Polished single-player core
    ↓
Warrior / Mage / Rogue / Priest
    ↓
More enemies
    ↓
More dungeon rooms
    ↓
Abilities
    ↓
Loot and progression
    ↓
Local multiplayer testing
    ↓
Online cooperative multiplayer
```

The eventual multiplayer architecture should be designed around the fact that the game is turn-based.

Players should submit actions to an authoritative game state rather than continuously synchronizing real-time movement.

For example:

```text
Player
    ↓
"I want to attack Goblin #4"
    ↓
Game rules
    ↓
Dice roll
    ↓
Combat result
    ↓
Updated game state
```

This is intentionally NOT part of the first prototype.

---

# 29. Core Design Principle

The central identity of the game should remain:

> **A fast, simple, cooperative digital tabletop dungeon crawler where movement and combat are driven by dice.**

The dice should create uncertainty.

The board should create tactical decisions.

The classes should eventually create cooperation.

The rules should remain simple enough that players can understand a turn without reading a rulebook.

The first prototype exists to answer one question:

> **Is rolling the dice, moving the Warrior, fighting the Goblin, and trying to survive fun?**

If the answer is yes, build the next layer.
