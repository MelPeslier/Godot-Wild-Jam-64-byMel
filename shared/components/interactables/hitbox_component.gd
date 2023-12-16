class_name HitboxComponent
extends Area2D

@export var attack_data: AttackData
@export var parent: Node2D
@export var damage: int
@export_range(0, 5000, 1) var knock_back: float


func _init() -> void:
	collision_layer = 2
	collision_mask = 0
