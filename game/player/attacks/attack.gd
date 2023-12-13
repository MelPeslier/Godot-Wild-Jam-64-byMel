class_name Attack
extends Node2D

@export_range(0.05, 25) var cooldown: float
@export var do_spawn_light_particles: bool = true
@export_range(0, 3000, 1) var light_particles_number: int = 8
@export_range(1, 4000, 1) var light_particles_sphere_size: float = 30
@export_range(0.1, 300) var light_particles_life_time: float = 1
@export_range(0, 1) var light_particles_explosiveness: float = 0.9

var can_attack := true
var attack_particles_scene: PackedScene
var player: Player

@onready var timer := Timer.new()
@onready var light_particles_scene: PackedScene = preload("res://shared/vfx/light_particles/light_particles.tscn")


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true
	timer.autostart = false


func play_attack() -> void:
	spawn_attack_particles()
	spawn_light_particles()
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack_particles() -> void:
	var attack_particles: AttackParticles = attack_particles_scene.instantiate()
	add_child(attack_particles)
	attack_particles.player = player


func spawn_light_particles() -> void:
	if not do_spawn_light_particles: return

	var light_particles: LightParticles = light_particles_scene.instantiate()
	add_child(light_particles)
	light_particles.play(light_particles_number, light_particles_sphere_size, light_particles_life_time, light_particles_explosiveness)
