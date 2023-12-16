class_name DetectorComponent
extends Area2D

@onready var collision_shape: CollisionShape2D = get_child(0) as CollisionShape2D


func _init() -> void:
	collision_layer = 0
	collision_mask = 16


func disable(do: bool) -> void:
	collision_shape.disabled = do
