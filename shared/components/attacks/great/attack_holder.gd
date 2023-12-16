class_name AttackHolder
extends Node2D

signal attack_up(_can_attack: bool, _damage: int)

@export_range(0.05, 45) var cooldown: float
@export_range(0, 10) var damage: int
@export var knock_back: float

var can_attack := true: set = _set_can_attack
@export var attack_scene: PackedScene
var parent: Node2D
var attack_data: AttackData

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true


func activate(_pos: Vector2 = parent.global_position) -> void:
	spawn_attack_particles(_pos)
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack_particles(_pos := parent.global_position) -> void:
	var attack_instance: AttackParticles = attack_scene.instantiate() as AttackParticles
	attack_instance.parent = parent
	attack_instance.attack_data = attack_data
	attack_instance.damage = damage
	attack_instance.knock_back = knock_back
	get_window().add_child(attack_instance)
	attack_instance.scale.x = get_parent().scale.x
	attack_instance.global_position = _pos


func _set_can_attack(_can_attack: bool) -> void:
	can_attack = _can_attack
	attack_up.emit(_can_attack, damage)
