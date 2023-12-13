class_name HitboxComponent
extends Area2D

@export var damage: int
@export_range(0, 5000, 1) var knock_back: float
@export_range(0, 2) var hit_stop: float
@export_range(0, 500) var hit_stop_shake: float
@export_range(0, 500) var camera_shake: float


func _init() -> void:
	collision_layer = 2
	collision_mask = 0
