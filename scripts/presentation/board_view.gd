class_name BoardView
extends Control

const BOARD_BACKGROUND := Color("18212b")
const FLOOR_COLOR := Color("273746")
const GRID_COLOR := Color("4a6070")
const CHEST_COLOR := Color("c9953b")
const WARRIOR_COLOR := Color("4aa3df")
const GOBLIN_COLOR := Color("d96565")

var board: Board

func set_board(value: Board) -> void:
	board = value
	queue_redraw()

func _draw() -> void:
	if board == null:
		return

	var tile_size := min(size.x / Board.COLUMNS, size.y / Board.ROWS)
	var board_size := Vector2(tile_size * Board.COLUMNS, tile_size * Board.ROWS)
	var origin := (size - board_size) / 2.0
	draw_rect(Rect2(origin, board_size), BOARD_BACKGROUND)

	for y in Board.ROWS:
		for x in Board.COLUMNS:
			var coordinate := Vector2i(x, y)
			var tile := board.get_tile(coordinate)
			var cell := Rect2(origin + Vector2(x, y) * tile_size, Vector2(tile_size, tile_size))
			var floor_color := Color("1f2b35") if tile.is_obstacle else FLOOR_COLOR
			draw_rect(cell, floor_color)
			draw_rect(cell, GRID_COLOR, false, 1.0)

			if board.is_chest_spawn(coordinate) and not tile.is_occupied():
				draw_circle(cell.get_center(), tile_size * 0.2, CHEST_COLOR)
				draw_string(ThemeDB.fallback_font, cell.position + Vector2(6, 18), "Chest", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, CHEST_COLOR)
			elif tile.is_occupied():
				var entity_color := WARRIOR_COLOR if tile.occupant == &"warrior" else GOBLIN_COLOR
				draw_circle(cell.get_center(), tile_size * 0.27, entity_color)
				draw_string(ThemeDB.fallback_font, cell.position + Vector2(6, 18), String(tile.occupant).capitalize(), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.WHITE)