class_name Hero
extends Entity

var ability_data: Dictionary

func _init(
	entity_identifier: StringName,
	initial_position: Vector2i,
	maximum_health: int,
	initial_ability_data: Dictionary = {}
) -> void:
	super(entity_identifier, initial_position, maxi(maximum_health, 1))
	ability_data = initial_ability_data.duplicate(true)
