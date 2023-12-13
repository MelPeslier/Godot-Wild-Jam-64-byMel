class_name AttackParticles
extends Node2D

@export var animator: AnimationPlayer
var player: Player

func _ready() -> void:
	animator.play("attack")
