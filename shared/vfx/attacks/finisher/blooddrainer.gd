extends Area2D

@export var attack_particles: AttackParticles


func drain_souls() -> void:
	var souls: Array = get_overlapping_areas()

	for soul: Soul in souls:
		if soul:
			soul.go_to(attack_particles.player)

