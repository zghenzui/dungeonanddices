extends Control

func _ready() -> void:
	$BoardView.set_board(Board.new())
