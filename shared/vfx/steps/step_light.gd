class_name StepLight
extends Node2D

@onready var animator: AnimationPlayer = $Animator
@onready var step_light_particles: GPUParticles2D = $step_light_particles
@onready var step: GPUParticles2D = $step

func play(coef: float) -> void:
	step_light_particles.amount_ratio = coef
	var light_process: ParticleProcessMaterial = step_light_particles.process_material as ParticleProcessMaterial
	light_process.initial_velocity_min = remap(coef, 0, 1, 0, light_process.initial_velocity_min)
	light_process.initial_velocity_max = remap(coef, 0, 1, 0, light_process.initial_velocity_max)

	var step_process: ParticleProcessMaterial = step.process_material as ParticleProcessMaterial
	step_process.scale_min = remap(coef, 0, 1, 0, step_process.scale_min)
	step_process.scale_max = remap(coef, 0, 1, 0, step_process.scale_max)

	animator.play("activate")
