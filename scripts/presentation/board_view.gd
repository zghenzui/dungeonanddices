class_name BoardView
extends Control

const BOARD_BACKGROUND := Color("18212b")
const FLOOR_COLOR := Color("273746")
const GRID_COLOR := Color("4a6070")
const CHEST_COLOR := Color("c9953b")
const WARRIOR_COLOR := Color("4aa3df")
const GOBLIN_COLOR := Color("d96565")
const LEGAL_COLOR := Color("58c79b")
const SELECTED_COLOR := Color("f5d76e")
const SHADOW_COLOR := Color(0.0, 0.0, 0.0, 0.32)

var board: Board
var legal_destinations: Array[Vector2i] = []
var selected_coordinate := Vector2i(-1, -1)
var _impact_coordinate := Vector2i(-1, -1)
var _impact_strength := 0.0

func set_board(value: Board) -> void:
	board = value
	queue_redraw()

func set_legal_destinations(value: Array[Vector2i]) -> void:
	legal_destinations = value
	queue_redraw()

func set_selected_coordinate(value: Vector2i) -> void:
	selected_coordinate = value
	queue_redraw()

func coordinate_at(local_position: Vector2) -> Vector2i:
	var geometry := _board_geometry()
	var origin: Vector2 = geometry.origin
	var tile_size: float = geometry.tile_size
	var coordinate := Vector2i(floori((local_position.x - origin.x) / tile_size), floori((local_position.y - origin.y) / tile_size))
	return coordinate if board != null and board.is_valid_coordinate(coordinate) else Vector2i(-1, -1)

func play_impact(coordinate: Vector2i) -> void:
	_impact_coordinate = coordinate
	_impact_strength = 1.0
	var tween := create_tween()
	tween.tween_method(_set_impact_strength, 1.0, 0.0, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _set_impact_strength(value: float) -> void:
	_impact_strength = value
	queue_redraw()

func _board_geometry() -> Dictionary:
	var tile_size: float = minf(size.x / Board.COLUMNS, size.y / Board.ROWS)
	var board_size: Vector2 = Vector2(tile_size * Board.COLUMNS, tile_size * Board.ROWS)
	return {"tile_size": tile_size, "board_size": board_size, "origin": (size - board_size) / 2.0}

func _draw() -> void:
	if board == null:
		return

	var geometry: Dictionary = _board_geometry()
	var tile_size: float = geometry.tile_size
	var board_size: Vector2 = geometry.board_size
	var origin: Vector2 = geometry.origin
	draw_rect(Rect2(origin, board_size), BOARD_BACKGROUND)

	for y in Board.ROWS:
		for x in Board.COLUMNS:
			var coordinate: Vector2i = Vector2i(x, y)
			var tile: Tile = board.get_tile(coordinate)
			var cell: Rect2 = Rect2(origin + Vector2(x, y) * tile_size, Vector2(tile_size, tile_size))
			var floor_color: Color = Color("1f2b35") if tile.is_obstacle else FLOOR_COLOR
			draw_rect(cell, floor_color)
			if coordinate in legal_destinations:
				draw_rect(cell.grow(-3.0), Color(LEGAL_COLOR, 0.22))
				draw_rect(cell.grow(-4.0), LEGAL_COLOR, false, 2.0)
			if coordinate == selected_coordinate:
				draw_rect(cell.grow(-3.0), SELECTED_COLOR, false, 4.0)
			draw_rect(cell, GRID_COLOR, false, 1.0)

			if tile.occupant == &"chest":
				draw_circle(cell.get_center(), tile_size * 0.2, CHEST_COLOR)
				draw_string(ThemeDB.fallback_font, cell.position + Vector2(6, 18), "Chest", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, CHEST_COLOR)
			elif tile.is_occupied():
				var entity_color: Color = WARRIOR_COLOR if tile.occupant == &"warrior" else GOBLIN_COLOR
				draw_circle(cell.get_center() + Vector2(3, 5), tile_size * 0.27, SHADOW_COLOR)
				draw_circle(cell.get_center(), tile_size * 0.27, entity_color)
				draw_string(ThemeDB.fallback_font, cell.position + Vector2(6, 18), String(tile.occupant).capitalize(), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.WHITE)

			if coordinate == _impact_coordinate and _impact_strength > 0.0:
				draw_circle(cell.get_center(), tile_size * (0.28 + 0.22 * (1.0 - _impact_strength)), Color(1.0, 0.9, 0.55, _impact_strength), false, 4.0)
