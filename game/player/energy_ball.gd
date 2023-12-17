class_name EnergyBall
extends Node2D

@export var color: Color: set = _set_color
@export_range(0, 1) var particle_ratio: float = 1: set = _set_particle_ratio
@export var speed: float = 300
@export var min_height: float = 100
@export var max_height: float = 300
@export var min_width: float = 50
@export var max_width: float = 150
@export var parent: Node2D


func _ready() -> void:
	speed *= randf_range(0.8, 1.2)
	min_height *= randf_range(0.8, 1.2)
	max_height *= randf_range(0.8, 1.2)
	min_width *= randf_range(0.8, 1.2)
	max_width *= randf_range(0.8, 1.2)
	color = color
	if not parent:
		set_process(false)


func _process(delta: float) -> void:
	#var dist: float = global_position.distance_to(parent.global_position)
	if not parent: return
	var dir: Vector2 = global_position.direction_to(parent.global_position)
	var dist: Vector2 = abs(global_position - parent.global_position)
	var direction := Vector2(-1.0, -1.0)
	if dir.x > 0:
		direction.x = 1.0
	if dir.y > 0:
		direction.y = 1.0

	dir.x = remap( abs( dist.x ), min_width, max_width, 0.0, 1.0)
	dir.x = maxf(dir.x, 0.0)

	dir.y = remap( abs( dist.y ), min_height, max_height, 0.0, 1.0)
	dir.y = maxf(dir.y, 0.0)
	global_position += direction * speed * dir * delta


func init(_parent: Node2D, _color: Color) -> void:
	color = _color
	parent = _parent


func _set_color(_color: Color) -> void:
	color = _color
	var particles: GPUParticles2D = $GPUParticles2D
	var process_mat : ParticleProcessMaterial = particles.process_material as ParticleProcessMaterial
	process_mat.color = color


func _set_particle_ratio(_ratio: float) -> void:
	particle_ratio = clampf(_ratio, 0.0, 1.0)
	var particles: GPUParticles2D = $GPUParticles2D
	particles.amount_ratio = _ratio
