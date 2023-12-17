extends ColorRect

const MIN_RADIUS: float = 0.65
const MAX_RADIUS: float = 1.0

@export var health_component: HealthComponent
@export var time_in: float
@export var time_out: float

var radius: float = MAX_RADIUS : set = _set_radius
var target_radius: float = MAX_RADIUS

var tween: Tween


func _on_health_component_health_changed(_health: int, _max_health: int) -> void:
	target_radius = remap(_health, 0, _max_health, MIN_RADIUS, MAX_RADIUS)
	var speed : float = time_in
	if target_radius > radius:
		speed = time_out

	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "radius", target_radius, speed)


func _set_radius(_radius: float) -> void:
	radius = clampf(_radius, MIN_RADIUS, MAX_RADIUS)

	var mat : ShaderMaterial = material as ShaderMaterial
	mat.set_shader_parameter("radius", radius)
