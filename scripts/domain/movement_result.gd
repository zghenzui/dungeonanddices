class_name MovementResult
extends RefCounted

var dice_results: Array[int]
var dice_roll: DiceRoll
var allowance: int
var remaining: int

func _init(roll: DiceRoll) -> void:
	dice_roll = roll
	dice_results = roll.results.duplicate()
	allowance = roll.total
	remaining = allowance

func spend(amount: int) -> bool:
	if amount < 0 or amount > remaining:
		return false
	remaining -= amount
	return true
