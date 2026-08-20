# Step 11: Presentation Polish

## Goal

Make the dice and core actions satisfying and readable without expanding the prototype's rules or content.

## Scope

- Improve dice presentation with a short roll animation.
- Add rotation, bounce, shadow, or impact feedback where useful.
- Add concise sounds for roll, hit, critical, defeat, and victory.
- Improve board readability, selected tiles, and legal movement feedback.
- Improve HP and outcome presentation.
- Preserve offline operation and placeholder-friendly asset choices.

## Constraints

- Presentation must read final dice values from `DiceRoll`.
- Animation must not change the authoritative game state.
- Gameplay input should be blocked or queued while a result animation is resolving.
- Do not add new heroes, enemies, levels, inventory, progression, or networking.

## Implementation Tasks

1. Add a presentation state for rolling and result display.
2. Animate dice from roll start to the known final values.
3. Add clear critical-hit and damage feedback.
4. Add movement and target highlighting.
5. Add audio with safe fallbacks when assets are unavailable.
6. Keep animations short enough that repeated turns remain fast.

## Acceptance Criteria

- Dice visibly roll and settle on the values produced by domain logic.
- The final value is readable after every roll.
- Critical attacks are distinguishable without relying on color alone.
- No input during animation can create duplicate rolls or transitions.
- Victory and game over remain immediately understandable.
- The game still runs without online services or required external assets.

## Definition Of Done

- [ ] Dice presentation is more satisfying than static text.
- [ ] Animation timing cannot desynchronize domain state.
- [ ] Core feedback works at the configured desktop window size.
- [ ] Existing rule and state-flow tests still pass.
- [ ] No unrelated feature scope was added.

## Validation

Play several consecutive turns and verify that every displayed dice result matches the resolved result, input remains consistent during animation, and the prototype remains responsive.
