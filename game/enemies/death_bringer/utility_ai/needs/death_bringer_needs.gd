class_name DeathBringerNeeds
extends AgentNeeds

@export var distance_to_opponent: float: set = _set_distance_to_opponent
@export var health: float: set = _set_health
@export var opponent_health: float: set = _set_opponent_health
@export var spell_damage: float: set = _set_spell_damage
@export var slash_damage: float: set = _set_slash_damage


func _set_distance_to_opponent(_distance_to_opponent: float) -> void:
	distance_to_opponent = clampf(_distance_to_opponent, 0.0, 1.0)


func _set_health(_health: float) -> void:
	health = clampf(_health, 0.0, 1.0)


func _set_opponent_health(_opponent_health: float) -> void:
	opponent_health = clampf(_opponent_health, 0.0, 1.0)


func _set_spell_damage(_spell_damage: float) -> void:
	spell_damage = clampf(_spell_damage, 0.0, 1.0)


func _set_slash_damage(_slash_damage: float) -> void:
	slash_damage = clampf(_slash_damage, 0.0, 1.0)
