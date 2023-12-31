class_name Attack
extends Node2D

signal attack_changed(_can: bool)

@export_range(0.05, 45) var cooldown: float
@export_range(0, 45,) var damage: int
@export var knock_back: float
@export var attack_particles_scene: PackedScene
@export var do_spawn_light_particles: bool = true
@export_range(0, 3000, 1) var light_particles_number: int = 8
@export_range(1, 4000, 1) var light_particles_sphere_size: float = 30
@export_range(0.1, 300) var light_particles_life_time: float = 1
@export_range(0, 1) var light_particles_explosiveness: float = 0.9

var can_attack := true : set = _set_can_attack
var parent: Node2D
var attack_data: AttackData

@onready var timer := Timer.new()
@onready var light_particles_scene: PackedScene = preload("res://shared/vfx/light_particles/light_particles.tscn")


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true


func play_attack() -> void:
	spawn_attack_particles()
	spawn_light_particles()
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack_particles() -> void:
	var attack_particles: AttackParticles = attack_particles_scene.instantiate() as AttackParticles
	attack_particles.parent = parent
	attack_particles.attack_data = attack_data
	attack_particles.damage = damage
	attack_particles.knock_back = knock_back
	add_child(attack_particles)


func spawn_light_particles() -> void:
	if not do_spawn_light_particles: return

	var light_particles: LightParticles = light_particles_scene.instantiate()
	add_child(light_particles)
	light_particles.play(light_particles_number, light_particles_sphere_size, light_particles_life_time, light_particles_explosiveness)


func _set_can_attack(_can: bool) -> void:
	can_attack = _can
	attack_changed.emit(can_attack)
