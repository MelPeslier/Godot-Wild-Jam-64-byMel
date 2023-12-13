extends PlayerState

@export var idle: State
@export var hit_effect: AfterHitEffectComponent


func enter() -> void:
	super()


func process_physics(delta: float) -> State:
	hit_effect.hit_stop -= delta
	if hit_effect.hit_stop > 0:
		return null

	return idle
