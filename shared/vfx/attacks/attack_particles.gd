class_name AttackParticles
extends Node2D

@export var deletion_time: float = 1.0
@export var particles: Array[GPUParticles2D]

@onready var timer := Timer.new()


func _ready() -> void:
	if particles.is_empty(): return

	for particle: GPUParticles2D in particles:
		particle.emitting = true

	add_child(timer)
	timer.autostart = false
	timer.one_shot = true
	timer.start(deletion_time)
	await timer.timeout
	queue_free()
