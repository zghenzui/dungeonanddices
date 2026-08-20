class_name Game
extends RefCounted

enum State {
	START,
	PLAYER_MOVEMENT,
	PLAYER_ATTACK,
	ENEMY_ATTACK,
	SECOND_ATTACK,
	VICTORY,
	GAME_OVER,
}

const VICTORY_MESSAGE := "DUNGEON CLEARED"
const GAME_OVER_MESSAGE := "GAME OVER"

var board: Board
var warrior: Warrior
var goblin: Goblin
var chest: Chest
var state: State = State.START
var latest_movement_result: MovementResult
var latest_player_attack: AttackResult
var latest_enemy_attack: AttackResult
var latest_enemy_roll: DiceRoll
var outcome_message: String = ""

var _random_source: Callable
var _combat := CombatSession.new()
var _enemy_attack_ends_turn := false

func _init(random_source: Callable = Callable()) -> void:
	_random_source = random_source
	board = Board.new()
	warrior = Warrior.new(Board.WARRIOR_START)
	goblin = Goblin.new(Board.GOBLIN_START)

func start() -> bool:
	if state != State.START:
		return false
	_enter_player_movement()
	return true

func valid_movement_destinations() -> Array[Vector2i]:
	if state != State.PLAYER_MOVEMENT or latest_movement_result == null:
		return []
	var destinations := board.valid_destinations(warrior.board_position, latest_movement_result.remaining)
	# Keep the configured reward location free so victory can always place its Chest.
	destinations.erase(Board.CHEST_SPAWN)
	return destinations

func move_player(destination: Vector2i) -> bool:
	if state != State.PLAYER_MOVEMENT or latest_movement_result == null:
		return false
	if destination == Board.CHEST_SPAWN:
		return false
	var distance := board.shortest_path_distance(warrior.board_position, destination)
	if distance < 0 or distance > latest_movement_result.remaining:
		return false
	if distance == 0:
		return true
	if not board.move_occupant(warrior.board_position, destination, warrior.identifier):
		return false
	warrior.board_position = destination
	latest_movement_result.spend(distance)
	return true

func finish_movement() -> bool:
	if state != State.PLAYER_MOVEMENT:
		return false
	if _can_reach_goblin():
		state = State.PLAYER_ATTACK
	else:
		_enter_player_movement()
	return true

func player_attack() -> bool:
	if state != State.PLAYER_ATTACK and state != State.SECOND_ATTACK:
		return false
	var was_second_attack := state == State.SECOND_ATTACK
	var result := _combat.resolve_warrior_attack(warrior, goblin, Dice.warrior_attack_roll(_random_source))
	if result == null:
		return false
	latest_player_attack = result
	if not goblin.alive:
		_enter_victory()
	elif was_second_attack:
		# A surviving Goblin retaliates after the Warrior's second strike, but this
		# counterattack always closes the turn instead of granting another strike.
		_enemy_attack_ends_turn = true
		state = State.ENEMY_ATTACK
	else:
		_enemy_attack_ends_turn = false
		state = State.ENEMY_ATTACK
	return true

func enemy_attack() -> bool:
	if state != State.ENEMY_ATTACK:
		return false
	latest_enemy_roll = Dice.goblin_attack_roll(_random_source)
	var result := _combat.resolve_goblin_attack(goblin, warrior, latest_enemy_roll)
	if result == null:
		return false
	latest_enemy_attack = result
	if not warrior.alive:
		state = State.GAME_OVER
		outcome_message = GAME_OVER_MESSAGE
	elif _enemy_attack_ends_turn:
		_enemy_attack_ends_turn = false
		_enter_player_movement()
	elif latest_enemy_roll.total < 5:
		state = State.SECOND_ATTACK
	else:
		_enter_player_movement()
	return true

func is_terminal() -> bool:
	return state == State.VICTORY or state == State.GAME_OVER

func _enter_player_movement() -> void:
	state = State.PLAYER_MOVEMENT
	latest_movement_result = MovementResult.new(Dice.movement_roll(_random_source))

func _can_reach_goblin() -> bool:
	if latest_movement_result == null or not goblin.alive:
		return false
	var directions: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	for direction in directions:
		var attack_position := goblin.board_position + direction
		if attack_position == warrior.board_position:
			return true
		var distance := board.shortest_path_distance(warrior.board_position, attack_position)
		if distance >= 0 and distance <= latest_movement_result.remaining:
			return true
	return false

func _enter_victory() -> void:
	board.remove_occupant(goblin.board_position, goblin.identifier)
	chest = Chest.new(Board.CHEST_SPAWN)
	board.place_occupant(chest.board_position, chest.identifier)
	state = State.VICTORY
	outcome_message = VICTORY_MESSAGE
