class_name AttackParticles
extends Node2D

@export var animator: AnimationPlayer

func _ready() -> void:
	animator.play("attack")
