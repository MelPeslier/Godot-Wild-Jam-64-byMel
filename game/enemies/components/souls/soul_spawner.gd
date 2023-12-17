extends Node2D

@export var soul_scene: PackedScene

func _on_timer_timeout() -> void:
	var soul_instance:Soul = soul_scene.instantiate() as Soul
	add_child(soul_instance)
	soul_instance.global_position = global_position + Vector2(randf_range(-300, 300), randf_range(-70, 70))
	soul_instance.init()
