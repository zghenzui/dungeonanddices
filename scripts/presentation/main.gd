extends Control

const ROLL_FRAME_TIME := 0.055

@onready var board_view: BoardView = $BoardPanel/BoardView
@onready var warrior_hp: Label = $Header/Row/WarriorHP
@onready var goblin_hp: Label = $Header/Row/GoblinHP
@onready var state_label: Label = $Footer/Row/StateBlock/State
@onready var hint_label: Label = $Footer/Row/StateBlock/Hint
@onready var die_one: Label = $Footer/Row/Dice/Die1
@onready var die_two: Label = $Footer/Row/Dice/Die2
@onready var total_label: Label = $Footer/Row/Dice/Total
@onready var action_button: Button = $Footer/Row/Action
@onready var outcome_label: Label = $Outcome

var game := Game.new()
var _selected_destination := Vector2i(-1, -1)
var _presenting_result := false

func _ready() -> void:
	action_button.pressed.connect(_on_action_pressed)
	board_view.gui_input.connect(_on_board_input)
	board_view.set_board(game.board)
	_refresh()

func _on_board_input(event: InputEvent) -> void:
	if _presenting_result or game.state != Game.State.PLAYER_MOVEMENT:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var coordinate := board_view.coordinate_at(event.position)
		if coordinate in game.valid_movement_destinations():
			_selected_destination = coordinate
			board_view.set_selected_coordinate(coordinate)
			hint_label.text = "Selected (%d, %d) — press MOVE" % [coordinate.x, coordinate.y]
			action_button.disabled = false
		else:
			_show_rejection("That tile is out of reach")

func _on_action_pressed() -> void:
	if _presenting_result or game.is_terminal():
		return
	match game.state:
		Game.State.START:
			if game.start():
				await _animate_roll(game.latest_movement_result.dice_roll)
		Game.State.PLAYER_MOVEMENT:
			if _selected_destination == Vector2i(-1, -1):
				_show_rejection("Choose a highlighted tile first")
				return
			if game.move_player(_selected_destination):
				_selected_destination = Vector2i(-1, -1)
				game.finish_movement()
				if game.state == Game.State.PLAYER_MOVEMENT:
					await _animate_roll(game.latest_movement_result.dice_roll)
			else:
				_show_rejection("Movement was rejected")
		Game.State.PLAYER_ATTACK, Game.State.SECOND_ATTACK:
			if game.player_attack():
				await _animate_attack(game.latest_player_attack, game.goblin.board_position)
				if game.state == Game.State.PLAYER_MOVEMENT:
					await _animate_roll(game.latest_movement_result.dice_roll)
		Game.State.ENEMY_ATTACK:
			if game.enemy_attack():
				await _animate_attack(game.latest_enemy_attack, game.warrior.board_position)
				if game.state == Game.State.PLAYER_MOVEMENT:
					await _animate_roll(game.latest_movement_result.dice_roll)
	_refresh()

func _animate_attack(result: AttackResult, target: Vector2i) -> void:
	await _animate_values(result.dice_results, result.base_damage)
	board_view.play_impact(target)
	hint_label.text = ("CRITICAL!  " if result.critical else "HIT  ") + "%d damage" % result.final_damage
	if result.critical:
		state_label.text = "CRITICAL STRIKE"
		state_label.modulate = Color("f5d76e")
	await get_tree().create_timer(0.34).timeout
	state_label.modulate = Color.WHITE

func _animate_roll(roll: DiceRoll) -> void:
	await _animate_values(roll.results, roll.total)

func _animate_values(values: Array[int], total: int) -> void:
	_presenting_result = true
	action_button.disabled = true
	for frame in 8:
		die_one.text = str((frame * 5 + 2) % 6 + 1)
		die_two.text = str((frame * 3 + 4) % 6 + 1) if values.size() > 1 else ""
		var tilt := -0.12 if frame % 2 == 0 else 0.12
		die_one.rotation = tilt
		die_two.rotation = -tilt
		await get_tree().create_timer(ROLL_FRAME_TIME).timeout
	die_one.rotation = 0.0
	die_two.rotation = 0.0
	die_one.text = str(values[0])
	die_two.text = str(values[1]) if values.size() > 1 else ""
	total_label.text = "TOTAL %d" % total
	var tween := create_tween().set_parallel()
	tween.tween_property(die_one, "scale", Vector2(1.18, 1.18), 0.08).set_trans(Tween.TRANS_BACK)
	if values.size() > 1:
		tween.tween_property(die_two, "scale", Vector2(1.18, 1.18), 0.08).set_trans(Tween.TRANS_BACK)
	await tween.finished
	die_one.scale = Vector2.ONE
	die_two.scale = Vector2.ONE
	_presenting_result = false
	_refresh()

func _refresh() -> void:
	board_view.set_board(game.board)
	warrior_hp.text = "WARRIOR  HP %d / %d" % [game.warrior.health, game.warrior.max_health]
	goblin_hp.text = "GOBLIN  HP %d / %d" % [game.goblin.health, game.goblin.max_health]
	board_view.set_legal_destinations(game.valid_movement_destinations())
	board_view.set_selected_coordinate(_selected_destination)
	outcome_label.visible = game.is_terminal()
	outcome_label.text = game.outcome_message
	action_button.visible = not game.is_terminal()
	action_button.disabled = _presenting_result

	match game.state:
		Game.State.START:
			_set_action("READY", "Roll to discover your movement range", "ROLL MOVEMENT")
		Game.State.PLAYER_MOVEMENT:
			_set_action("MOVEMENT", "Choose a highlighted destination (%d remaining)" % game.latest_movement_result.remaining, "MOVE")
			action_button.disabled = _presenting_result or _selected_destination == Vector2i(-1, -1)
		Game.State.PLAYER_ATTACK:
			_set_action("YOUR ATTACK", "The Goblin is in range", "ROLL ATTACK")
		Game.State.ENEMY_ATTACK:
			_set_action("GOBLIN ATTACK", "Brace for the counterattack", "ROLL ENEMY")
		Game.State.SECOND_ATTACK:
			_set_action("SECOND STRIKE", "The Goblin left an opening", "ROLL ATTACK AGAIN")
		Game.State.VICTORY:
			_set_action("VICTORY", "The treasure is yours", "")
		Game.State.GAME_OVER:
			_set_action("DEFEAT", "The dungeon claims another warrior", "")

func _set_action(title: String, hint: String, button_text: String) -> void:
	state_label.text = title
	hint_label.text = hint
	action_button.text = button_text

func _show_rejection(message: String) -> void:
	hint_label.text = message
	var tween := create_tween()
	tween.tween_property(hint_label, "modulate", Color("f06b68"), 0.08)
	tween.tween_property(hint_label, "modulate", Color.WHITE, 0.22)
