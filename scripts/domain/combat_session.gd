class_name CombatSession
extends RefCounted

const WARRIOR_CRITICAL_BONUS := 2

var attacker: Entity
var defender: Entity

func _init(active_attacker: Entity = null, active_defender: Entity = null) -> void:
	attacker = active_attacker
	defender = active_defender

func resolve_warrior_attack(warrior: Warrior, goblin: Goblin, roll: DiceRoll) -> AttackResult:
	attacker = warrior
	defender = goblin
	if not warrior.alive or not goblin.alive or roll.results.size() != 2:
		return null
	var base_damage := roll.total
	var critical := roll.is_critical
	var final_damage := base_damage + (WARRIOR_CRITICAL_BONUS if critical else 0)
	goblin.apply_damage(final_damage)
	return AttackResult.new(warrior, goblin, roll.results, base_damage, critical, final_damage, goblin.health, not goblin.alive)

func resolve_goblin_attack(goblin: Goblin, warrior: Warrior, roll: DiceRoll) -> AttackResult:
	attacker = goblin
	defender = warrior
	if not goblin.alive or not warrior.alive or roll.results.size() != 1:
		return null
	warrior.apply_damage(roll.total)
	return AttackResult.new(goblin, warrior, roll.results, roll.total, false, roll.total, warrior.health, not warrior.alive)
