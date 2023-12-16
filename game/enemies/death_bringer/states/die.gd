extends MoveState

@export var soul_scene: PackedScene


func spawn_soul() -> void:
	var soul_instance: Soul = soul_scene.instantiate() as Soul
	get_window().add_child(soul_instance)
	soul_instance.global_position = parent.global_position
