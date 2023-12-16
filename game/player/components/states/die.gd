extends PlayerState


func enter() -> void:
	super()
	GameManager.player_died()


func process_physics(_delta: float) -> State:
	return null
