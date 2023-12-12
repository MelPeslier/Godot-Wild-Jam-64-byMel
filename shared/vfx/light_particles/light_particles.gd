class_name LightParticles
extends Node2D

@export var light_particles: GPUParticles2D

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.autostart = true
	timer.one_shot = true


func play(number: int, sphere_size: float, _lifetime: float = 1, _explosiveness: float = 0.9) -> void:
	var process := light_particles.process_material as ParticleProcessMaterial
	process.emission_sphere_radius = sphere_size
	light_particles.lifetime = _lifetime
	light_particles.explosiveness = _explosiveness
	light_particles.amount = number
	light_particles.emitting = true

	timer.start(light_particles.lifetime * 2.0)
	await timer.timeout
	queue_free()
