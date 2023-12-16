extends Camera2D

var shake_strength: float = 0
var shake_fade: float = 0
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	set_process(false)
	GameEvents.screen_shake.connect(_on_screen_shake)


func _process(delta: float) -> void:
	if not shake_strength > 0:
		shake_strength = 0
		shake_fade = 0
		offset = Vector2.ZERO
		set_process(false)
		return
	shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
	offset = _get_random_val(shake_strength)


func _on_screen_shake(_strength: float, _fade: float) -> void:
	shake_strength = _strength
	shake_fade = _fade
	set_process(true)


func _get_random_val(val: float) -> Vector2:
	return Vector2(rng.randf_range( -val, val ), rng.randf_range( -val, val ) )

