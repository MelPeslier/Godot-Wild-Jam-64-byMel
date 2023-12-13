extends PlayerState

@export var hit_effect: AfterHitEffectComponent


func enter() -> void:
	super()
	GameManager.player_died()


func process_physics(delta: float) -> State:
	return null
