class_name AttackParticles
extends Node2D

@export var animator: AnimationPlayer
var parent: Node2D
var attack_data: AttackData

@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	hitbox_component.parent = parent
	hitbox_component.attack_data = attack_data
	animator.play("attack")
