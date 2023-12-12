extends CanvasLayer

@export var animator: AnimationPlayer
@export var particles_spaw: Marker2D

@onready var twirl_particles: PackedScene = preload("res://autoloads/scene_transition/twirl_particles.tscn")
@onready var control_root: Control = $ControlRoot


func change_scene(target_path: String) -> void:
	control_root.mouse_filter = Control.MOUSE_FILTER_STOP
	animator.play("APPEAR")

	await animator.animation_finished

	get_tree().change_scene_to_file(target_path)
	control_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animator.play("DISSIPATE")


func spawn_particles() -> void:
	particles_spaw.add_child(twirl_particles.instantiate())


func delete_particles() -> void:
	if particles_spaw.get_child_count() == 0:
		return

	for i in particles_spaw.get_children():
		i.queue_free()
