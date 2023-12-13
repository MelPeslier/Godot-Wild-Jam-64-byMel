extends Attack

@onready var attack_scene: PackedScene = preload("res://shared/vfx/attacks/right_slash/slash_particles_right.tscn")


func _ready() -> void:
	super()
	attack_particles_scene = attack_scene
