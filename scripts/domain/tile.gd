class_name Tile
extends RefCounted

var coordinate: Vector2i
var occupant: StringName = &""
var is_obstacle: bool = false

func _init(tile_coordinate: Vector2i) -> void:
	coordinate = tile_coordinate

func is_occupied() -> bool:
	return occupant != &""