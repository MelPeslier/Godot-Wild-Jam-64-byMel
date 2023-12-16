class_name DetectableComponent
extends Area2D

@export var parent := Node2D


func _init() -> void:
	collision_layer = 16
	collision_mask = 0
