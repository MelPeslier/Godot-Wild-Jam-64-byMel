extends Attack

@onready var attack_scene: PackedScene = preload("res://shared/vfx/attacks/finisher/finisher_particles.tscn")


func _ready() -> void:
	super()
	attack_particles_scene = attack_scene
