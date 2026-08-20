class_name Enemy
extends Entity

var attack_die_count: int
var attack_die_sides: int

func _init(
	entity_identifier: StringName,
	initial_position: Vector2i,
	maximum_health: int,
	initial_attack_die_count: int,
	initial_attack_die_sides: int
) -> void:
	super(entity_identifier, initial_position, maxi(maximum_health, 1))
	attack_die_count = maxi(initial_attack_die_count, 1)
	attack_die_sides = maxi(initial_attack_die_sides, 2)
