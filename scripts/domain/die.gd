class_name Die
extends RefCounted

var sides: int
var _random_source: Callable

func _init(die_sides: int, random_source: Callable = Callable()) -> void:
	assert(die_sides >= 2, "A die must have at least two sides.")
	sides = die_sides
	_random_source = random_source

func roll() -> int:
	var result: int
	if _random_source.is_valid():
		result = int(_random_source.call(1, sides))
	else:
		result = randi_range(1, sides)

	assert(result >= 1 and result <= sides, "The random source returned an invalid die result.")
	return result

