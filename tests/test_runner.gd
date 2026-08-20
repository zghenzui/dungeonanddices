extends SceneTree

class FixedRandom:
	extends RefCounted
	var values: Array[int]
	var index := 0
	func _init(fixed_values: Array[int]) -> void:
		values = fixed_values
	func next_value(_minimum: int, _maximum: int) -> int:
		var value := values[index]
		index += 1
		return value

var failures := 0
var _random_sources: Array[FixedRandom] = []

func _init() -> void:
	_test_entities()
	_test_dice_and_combat()
	_test_board()
	_test_state_flows()
	_test_scene_contract()
	print("PASS: Dice Dungeon prototype test suite" if failures == 0 else "FAIL: %d assertions" % failures)
	quit(failures)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _test_entities() -> void:
	var warrior := Warrior.new(Vector2i(2, 3))
	var goblin := Goblin.new()
	_check(warrior.health == 5 and warrior.alive, "Warrior defaults")
	_check(goblin.health == 10 and goblin.alive, "Goblin defaults")
	warrior.apply_damage(99)
	_check(warrior.health == 0 and not warrior.alive, "Damage clamps and kills")
	_check(warrior.apply_damage(1) == 0, "Dead entity rejects damage")

func _test_dice_and_combat() -> void:
	var matching := Dice.fixed_warrior_attack_roll([2, 2])
	_check(matching.total == 4 and matching.is_critical, "Matching 2d6 critical")
	_check(not Dice.fixed_warrior_attack_roll([2, 3]).is_critical, "Non-matching 2d6")
	_check(not Dice.fixed_goblin_attack_roll([4]).is_critical, "Goblin roll is not critical")
	var goblin := Goblin.new()
	var result := CombatSession.new().resolve_warrior_attack(Warrior.new(), goblin, matching)
	_check(result.final_damage == 6 and result.critical and goblin.health == 4, "Critical combat damage")

func _test_board() -> void:
	var board := Board.new()
	_check(not board.is_valid_coordinate(Vector2i.ZERO), "Level 1 origin is a void tile")
	_check(board.is_valid_coordinate(Vector2i(1, 0)), "Level 1 floor tile is valid")
	_check(not board.is_valid_coordinate(Vector2i(12, 7)), "Board edge invalid")
	_check(board.get_tile(Vector2i(5, 2)) == null, "Interior void has no tile")
	_check(board.is_occupied(Board.WARRIOR_START), "Warrior occupies start")
	_check(not board.can_occupy(Board.GOBLIN_START), "Occupied destination rejected")
	_check(board.manhattan_distance(Vector2i(1, 1), Vector2i(4, 5)) == 7, "Manhattan distance")

func _test_state_flows() -> void:
	var unreachable := _game_with_values([1, 1, 2, 2])
	_check(unreachable.start() and unreachable.latest_movement_result.allowance == 2, "Start enters movement")
	unreachable.finish_movement()
	_check(unreachable.state == Game.State.PLAYER_MOVEMENT and unreachable.latest_movement_result.dice_results == [2, 2], "Unreachable starts next turn")

	var victory := _game_with_values([6, 6, 5, 5])
	victory.start()
	_check(not victory.move_player(Board.CHEST_SPAWN), "Reserved Chest tile rejects movement")
	_check(victory.move_player(Vector2i(9, 2)), "Exact-distance movement")
	victory.finish_movement()
	_check(victory.state == Game.State.PLAYER_ATTACK, "Reachable enters attack")
	victory.player_attack()
	_check(victory.state == Game.State.VICTORY and victory.board.get_tile(Board.CHEST_SPAWN).occupant == &"chest", "Victory spawns chest")
	_check(not victory.player_attack(), "Victory is terminal")

	var game_over := _game_with_values([6, 6, 1, 1, 5])
	game_over.start()
	game_over.move_player(Vector2i(9, 2))
	game_over.finish_movement()
	game_over.player_attack()
	game_over.enemy_attack()
	_check(game_over.state == Game.State.GAME_OVER and game_over.warrior.health == 0, "Game over")
	_check(not game_over.enemy_attack(), "Game over is terminal")

	var second := _game_with_values([6, 6, 1, 2, 4, 3, 3])
	second.start()
	second.move_player(Vector2i(9, 2))
	second.finish_movement()
	second.player_attack()
	second.enemy_attack()
	_check(second.state == Game.State.SECOND_ATTACK, "Low Goblin roll enables second strike")
	second.player_attack()
	_check(second.state == Game.State.VICTORY, "Second strike victory")

	var second_counter := _game_with_values([6, 6, 1, 1, 1, 1, 2, 2, 2, 2])
	second_counter.start()
	second_counter.move_player(Vector2i(9, 2))
	second_counter.finish_movement()
	second_counter.player_attack()
	second_counter.enemy_attack()
	second_counter.player_attack()
	_check(second_counter.state == Game.State.ENEMY_ATTACK, "Surviving second strike triggers a counterattack")
	second_counter.enemy_attack()
	_check(second_counter.state == Game.State.PLAYER_MOVEMENT, "Second counterattack ends the turn")
	_check(second_counter.warrior.health == 2, "Second counterattack applies damage")

func _test_scene_contract() -> void:
	var scene := load("res://scenes/main_scene.tscn") as PackedScene
	_check(scene != null, "Main scene loads")
	if scene:
		var root := scene.instantiate()
		_check(root.get_node_or_null("Header/Row/WarriorHP") != null, "HP label exists")
		_check(root.get_node_or_null("Footer/Row/Action") != null, "Action exists")
		_check(root.get_node_or_null("Outcome") != null, "Outcome exists")
		root.free()

func _game_with_values(values: Array[int]) -> Game:
	var source := FixedRandom.new(values)
	# A Callable does not keep its RefCounted target alive. Retain each deterministic
	# source for the lifetime of the suite so rolls do not fall back to randomness.
	_random_sources.append(source)
	return Game.new(source.next_value)
