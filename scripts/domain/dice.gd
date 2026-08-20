class_name Dice
extends RefCounted

const D6_SIDES: int = 6

static func movement_roll(random_source: Callable = Callable()) -> DiceRoll:
	return _roll_d6(2, true, random_source)

static func warrior_attack_roll(random_source: Callable = Callable()) -> DiceRoll:
	return _roll_d6(2, true, random_source)

static func goblin_attack_roll(random_source: Callable = Callable()) -> DiceRoll:
	return _roll_d6(1, false, random_source)

static func fixed_movement_roll(results: Array[int]) -> DiceRoll:
	_validate_fixed_d6_results(results, 2)
	return DiceRoll.new(results, true)

static func fixed_warrior_attack_roll(results: Array[int]) -> DiceRoll:
	_validate_fixed_d6_results(results, 2)
	return DiceRoll.new(results, true)

static func fixed_goblin_attack_roll(results: Array[int]) -> DiceRoll:
	_validate_fixed_d6_results(results, 1)
	return DiceRoll.new(results, false)

static func _roll_d6(count: int, critical_eligible: bool, random_source: Callable) -> DiceRoll:
	var results: Array[int] = []
	var die := Die.new(D6_SIDES, random_source)
	for index in count:
		results.append(die.roll())
	return DiceRoll.new(results, critical_eligible)

static func _validate_fixed_d6_results(results: Array[int], expected_count: int) -> void:
	assert(results.size() == expected_count, "Unexpected number of dice results.")
	for result in results:
		assert(result >= 1 and result <= D6_SIDES, "A d6 result must be between 1 and 6.")
