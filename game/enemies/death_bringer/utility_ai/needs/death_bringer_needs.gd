class_name DeathBringerNeeds
extends AgentNeeds

@export var distance_to_opponent: float = 0.1: set = _set_distance_to_opponent
@export var health: float = 0.7: set = _set_health
@export var opponent_health: float = 0.7: set = _set_health


func _set_distance_to_opponent(_distance_to_opponent: float) -> void:
	distance_to_opponent = clampf(_distance_to_opponent, 0.0, 1.0)


func _set_health(_health: float) -> void:
	health = clampf(_health, 0.0, 1.0)


func _set_opponent_health(_opponent_health: float) -> void:
	health = clampf(_opponent_health, 0.0, 1.0)
