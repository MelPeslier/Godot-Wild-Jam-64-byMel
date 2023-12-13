extends PlayerState

@export var idle: State


func enter() -> void:
	super()
	player.burst_timer = player.burst_time


func process_physics(delta: float) -> State:
	player.burst_timer -= delta
	if player.burst_timer > 0:
		return null

	return idle
