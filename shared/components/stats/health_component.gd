class_name HealthComponent
extends Node

signal health_changed(heath: int)

@export var max_health: int

var health: int:
	set(val):
		health = val
		health_changed.emit(health)


func _ready() -> void:
	health = max_health


func dammage(_dammage: int) -> void:
	health = max(health - _dammage, 0)


func heal(amount: int) -> void:
	health = min(health + amount, max_health)
