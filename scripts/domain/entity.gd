class_name Entity
extends RefCounted

var identifier: StringName
var board_position: Vector2i
var alive: bool = true
var max_health: int
var health: int

func _init(
	entity_identifier: StringName,
	initial_position: Vector2i = Vector2i.ZERO,
	maximum_health: int = 0
) -> void:
	identifier = entity_identifier
	board_position = initial_position
	max_health = maxi(maximum_health, 0)
	health = max_health

func apply_damage(amount: int) -> int:
	if amount <= 0 or not alive or max_health == 0:
		return 0

	var previous_health := health
	health = maxi(health - amount, 0)
	alive = health > 0
	return previous_health - health

func heal(amount: int) -> int:
	if amount <= 0 or not alive or max_health == 0:
		return 0

	var previous_health := health
	health = mini(health + amount, max_health)
	return health - previous_health
