class_name AttackParticles
extends Node2D

var parent: Node2D
var attack_data: AttackData
var damage: int
var knock_back: float

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hitbox_component.attack_data = attack_data
	if damage > 0:
		hitbox_component.damage = damage
	if knock_back > 0:
		hitbox_component.knock_back = knock_back
	for child in get_children():
		if child is Area2D:
			child.parent = parent
	animation_player.play("activate")
