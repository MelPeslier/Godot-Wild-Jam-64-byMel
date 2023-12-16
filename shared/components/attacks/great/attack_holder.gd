class_name AttackHolder
extends Node2D

@export_range(0.05, 45) var cooldown: float

var can_attack := true
@export var attack_scene: PackedScene
var parent: Node2D
var attack_data: AttackData

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true


func activate() -> void:
	spawn_attack_particles()
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack_particles() -> void:
	var attack_instance: AttackParticles = attack_scene.instantiate()
	attack_instance.parent = parent
	attack_instance.attack_data = attack_data
	add_child(attack_instance)

