class_name Warrior
extends Hero

const MAX_HEALTH: int = 5

func _init(initial_position: Vector2i = Vector2i.ZERO) -> void:
	super(&"warrior", initial_position, MAX_HEALTH)

