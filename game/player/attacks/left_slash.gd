extends Attack

@onready var attack_scene: PackedScene = preload("res://shared/vfx/attacks/left_slash/slash_particles_left.tscn")


func _ready() -> void:
	super()
	attack_particles_scene = attack_scene
