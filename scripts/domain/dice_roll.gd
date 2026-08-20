class_name DiceRoll
extends RefCounted

var results: Array[int]
var total: int
var matching_results: bool
var is_critical: bool

func _init(roll_results: Array[int], critical_eligible: bool = false) -> void:
	assert(not roll_results.is_empty(), "A dice roll must contain at least one result.")
	results = roll_results.duplicate()
	total = 0
	for result in results:
		assert(result > 0, "Dice results must be positive integers.")
		total += result

	matching_results = results.size() > 1 and results.all(_matches_first_result)
	is_critical = critical_eligible and results.size() == 2 and matching_results

func _matches_first_result(result: int) -> bool:
	return result == results[0]

