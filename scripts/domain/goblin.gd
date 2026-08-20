class_name Goblin
extends Enemy

const MAX_HEALTH: int = 10
const ATTACK_DIE_COUNT: int = 1
const ATTACK_DIE_SIDES: int = 6

func _init(initial_position: Vector2i = Vector2i.ZERO) -> void:
	super(&"goblin", initial_position, MAX_HEALTH, ATTACK_DIE_COUNT, ATTACK_DIE_SIDES)

