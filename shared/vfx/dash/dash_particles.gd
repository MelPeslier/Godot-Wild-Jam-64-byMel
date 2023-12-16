class_name DashParticles
extends Node2D

@onready var animator: AnimationPlayer = $Animator
@onready var trace: GPUParticles2D = $trace


func play(direction: float) -> void:
	var trace_process: ParticleProcessMaterial = trace.process_material as ParticleProcessMaterial
	trace_process.direction.x = direction
	animator.play("activate")
