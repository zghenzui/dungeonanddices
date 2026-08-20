class_name Board
extends RefCounted

const COLUMNS: int = 12
const ROWS: int = 8
const WARRIOR_START := Vector2i(1, 6)
const GOBLIN_START := Vector2i(10, 2)
const CHEST_SPAWN := Vector2i(9, 6)
const STATIC_OBSTACLES: Array[Vector2i] = []
const VOID_TILES: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(7, 0), Vector2i(8, 0), Vector2i(9, 0), Vector2i(10, 0), Vector2i(11, 0),
	Vector2i(9, 1), Vector2i(10, 1), Vector2i(11, 1),
	Vector2i(5, 2), Vector2i(6, 2),
	Vector2i(0, 3), Vector2i(1, 3), Vector2i(5, 3), Vector2i(6, 3),
	Vector2i(0, 4), Vector2i(1, 4), Vector2i(10, 4), Vector2i(11, 4),
	Vector2i(0, 5), Vector2i(10, 5), Vector2i(11, 5),
	Vector2i(0, 6),
	Vector2i(0, 7), Vector2i(1, 7), Vector2i(2, 7), Vector2i(3, 7), Vector2i(11, 7),
]

var _tiles: Dictionary = {}

func _init() -> void:
	for y in ROWS:
		for x in COLUMNS:
			var coordinate := Vector2i(x, y)
			if coordinate in VOID_TILES:
				continue
			var tile := Tile.new(coordinate)
			tile.is_obstacle = coordinate in STATIC_OBSTACLES
			_tiles[coordinate] = tile

	place_occupant(WARRIOR_START, &"warrior")
	place_occupant(GOBLIN_START, &"goblin")

func is_valid_coordinate(coordinate: Vector2i) -> bool:
	return _tiles.has(coordinate)

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

func manhattan_distance(from: Vector2i, to: Vector2i) -> int:
	return abs(from.x - to.x) + abs(from.y - to.y)

func remove_occupant(coordinate: Vector2i, expected: StringName = &"") -> bool:
	var tile := get_tile(coordinate)
	if tile == null or not tile.is_occupied():
		return false
	if expected != &"" and tile.occupant != expected:
		return false
	tile.occupant = &""
	return true

func move_occupant(from: Vector2i, to: Vector2i, expected: StringName = &"") -> bool:
	var source := get_tile(from)
	if source == null or not source.is_occupied() or not can_occupy(to):
		return false
	if expected != &"" and source.occupant != expected:
		return false
	var occupant := source.occupant
	source.occupant = &""
	get_tile(to).occupant = occupant
	return true

func shortest_path_distance(from: Vector2i, to: Vector2i) -> int:
	if not is_valid_coordinate(from) or not is_valid_coordinate(to):
		return -1
	if from == to:
		return 0
	if is_occupied(to) or get_tile(to).is_obstacle:
		return -1
	var frontier: Array[Vector2i] = [from]
	var distances: Dictionary = {from: 0}
	var directions: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		for direction in directions:
			var next := current + direction
			if next in distances or not is_valid_coordinate(next):
				continue
			var tile := get_tile(next)
			if tile.is_obstacle or tile.is_occupied():
				continue
			distances[next] = int(distances[current]) + 1
			if next == to:
				return distances[next]
			frontier.append(next)
	return -1

func valid_destinations(from: Vector2i, allowance: int) -> Array[Vector2i]:
	var destinations: Array[Vector2i] = []
	if not is_valid_coordinate(from) or allowance < 0:
		return destinations
	for coordinate in _tiles:
		if coordinate == from:
			destinations.append(coordinate)
			continue
		var distance := shortest_path_distance(from, coordinate)
		if distance >= 0 and distance <= allowance:
			destinations.append(coordinate)
	return destinations
