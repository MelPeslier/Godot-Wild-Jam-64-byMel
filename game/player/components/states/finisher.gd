extends PlayerState

@export var idle: State


func enter() -> void:
	super()
	player.finisher_timer = player.finisher_time


func process_physics(delta: float) -> State:
	player.finisher_timer -= delta
	if player.finisher_timer > 0:
		return null
	return idle

