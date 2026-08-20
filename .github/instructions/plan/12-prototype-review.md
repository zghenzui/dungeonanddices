# Step 12: Prototype Review

## Goal

Evaluate the complete offline prototype against its central question: is rolling, moving, fighting, and surviving fun enough to continue?

## Review Scope

Review the complete loop:

```text
START
-> roll movement
-> move Warrior
-> engage Goblin when reachable
-> roll Warrior attack
-> resolve critical or normal damage
-> resolve Goblin counterattack
-> allow or deny second strike
-> reach victory or game over
```

## Implementation And Playtest Tasks

1. Run the full automated test suite.
2. Play several complete sessions from a clean launch.
3. Check that rules are understandable without reading source code.
4. Record confusing moments, pacing issues, and dice feedback quality.
5. Audit the project for excluded features and accidental dependencies.
6. Fix only defects that prevent the prototype from answering the core question.

## Review Questions

- Is the next action obvious at every state?
- Do movement results create meaningful positioning decisions?
- Does the Goblin counterattack create tension without making turns tedious?
- Does the second-strike rule feel understandable and fair?
- Are critical hits noticeable and rewarding?
- Is the dice result presentation satisfying enough to repeat the loop?
- Can a player finish a session without encountering a blocked or invalid action?

## Acceptance Criteria

- A fresh launch reaches the first movement roll.
- A complete session can end in victory or game over.
- Automated tests pass.
- No prototype-excluded feature has been introduced.
- Known defects and playtest observations are recorded.
- The team makes an explicit `continue`, `revise`, or `stop` decision.

## Definition Of Done

- [ ] Core loop is playable from start to terminal outcome.
- [ ] Rules and state transitions are covered by tests.
- [ ] Playtest notes identify the strongest and weakest parts of the loop.
- [ ] Scope audit confirms offline-first boundaries remain intact.
- [ ] Next work is chosen from observed evidence rather than speculative architecture.

## Possible Outcomes

### Continue

The core loop is fun enough to justify more content, classes, enemies, or rooms.

### Revise

The loop is promising, but a specific rule, pacing issue, or presentation problem must be corrected first.

### Stop

The prototype does not provide enough evidence of fun to justify expanding the system.

## Validation

Attach the test result and a short playtest report to this step. Do not begin online multiplayer, accounts, persistence, or progression until the review explicitly supports expansion.
