class_name AttackResult
extends RefCounted

var attacker: Entity
var defender: Entity
var dice_results: Array[int]
var base_damage: int
var critical: bool
var final_damage: int
var target_hp_after: int
var target_died: bool

func _init(
	attack_source: Entity,
	attack_target: Entity,
	results: Array[int],
	damage: int,
	is_critical: bool,
	resolved_damage: int,
	hp_after: int,
	died: bool
) -> void:
	attacker = attack_source
	defender = attack_target
	dice_results = results.duplicate()
	base_damage = damage
	critical = is_critical
	final_damage = resolved_damage
	target_hp_after = hp_after
	target_died = died
