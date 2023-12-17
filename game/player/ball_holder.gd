class_name BallHolder
extends Node2D

@export var color: Color
@export var attack: EnergyAttack


var ball_scene: PackedScene = preload("res://game/player/energy_ball.tscn")
@onready var ball_instance: EnergyBall = ball_scene.instantiate() as EnergyBall

func _ready() -> void:
	get_window().add_child.call_deferred(ball_instance)
	ball_instance.global_position = global_position
	ball_instance.init(self, color)
	attack.attack_changed.connect(_on_attack_changed)


func _on_attack_changed(_can: bool) -> void:
	var amount: float = 0
	if _can:
		amount = 1.0
	ball_instance.particle_ratio = amount



