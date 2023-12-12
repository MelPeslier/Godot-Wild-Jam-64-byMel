class_name HitboxComponent
extends Area2D

@export var damage: int
@export var knockback: float
@export var hitstop: int


func _init() -> void:
	collision_layer = 2
	collision_mask = 0
