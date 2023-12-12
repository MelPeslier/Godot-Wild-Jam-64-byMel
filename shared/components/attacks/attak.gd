class_name Attack
extends Node2D

@export_range(0.05, 14) var cooldown: float
@export var animator: AnimationPlayer

var can_attack := true
@onready var timer = Timer.new()


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true
	timer.autostart = false


func play() -> void:
	animator.play("attack")
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true
