extends MoveState

@export var fall: State

@export_category("change_state")
@export_range(0.05, 30) var wait_time: float = 5
@export_range(0, 0.9) var rand_coef: float = 0.3
@export var walk: State

var wait_timer: float


func enter() -> void:
	super()
	wait_timer = wait_time + rand_coef * randf_range(-wait_time, wait_time)


func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	parent.move_and_slide()
	if not parent.is_on_floor():
		return fall
	return null


func process_frame(delta: float) -> State:
	wait_timer -= delta
	if wait_timer > 0:
		return null
	return walk
