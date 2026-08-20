class_name Board
extends RefCounted

const COLUMNS: int = 12
const ROWS: int = 8
const WARRIOR_START := Vector2i(1, 6)
const GOBLIN_START := Vector2i(10, 2)
const CHEST_SPAWN := Vector2i(9, 6)
const STATIC_OBSTACLES: Array[Vector2i] = []

var _tiles: Dictionary = {}

func _init() -> void:
	for y in ROWS:
		for x in COLUMNS:
			var coordinate := Vector2i(x, y)
			var tile := Tile.new(coordinate)
			tile.is_obstacle = coordinate in STATIC_OBSTACLES
			_tiles[coordinate] = tile

	place_occupant(WARRIOR_START, &"warrior")
	place_occupant(GOBLIN_START, &"goblin")

func is_valid_coordinate(coordinate: Vector2i) -> bool:
	return coordinate.x >= 0 and coordinate.x < COLUMNS and coordinate.y >= 0 and coordinate.y < ROWS

func get_tile(coordinate: Vector2i) -> Tile:
	return _tiles.get(coordinate)

func is_occupied(coordinate: Vector2i) -> bool:
	var tile := get_tile(coordinate)
	return tile != null and tile.is_occupied()

func can_occupy(coordinate: Vector2i) -> bool:
	var tile := get_tile(coordinate)
	return tile != null and not tile.is_obstacle and not tile.is_occupied()

func place_occupant(coordinate: Vector2i, occupant: StringName) -> bool:
	if not can_occupy(coordinate) or occupant == &"":
		return false
	get_tile(coordinate).occupant = occupant
	return true

func is_chest_spawn(coordinate: Vector2i) -> bool:
	return coordinate == CHEST_SPAWN