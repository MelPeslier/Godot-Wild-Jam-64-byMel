extends MoveState

@export var fall: State

@export_category("change_state")
@export_range(0.05, 30) var wait_time: float = 5
@export_range(0, 0.9) var rand_wait_time_coef: float = 0.3
@export var idle: State
@export var walk: State
@export_range(0, 1) var idle_walk_threshold: float = 0.75

var wait_timer: float


func enter() -> void:
	super()
	wait_timer = wait_time + rand_wait_time_coef * randf_range(-wait_time, wait_time)
	move_data.dir = int( get_movement_input() )


func process_physics(delta: float) -> State:
	do_walk_accelerate(delta)
	parent.move_and_slide()

	if parent.is_on_wall():
		move_data.dir *= -1

	if not parent.is_on_floor():
		return fall

	return null


func process_frame(delta: float) -> State:
	# Out conditions
	wait_timer -= delta
	if wait_timer > 0:
		return null
	var next_state := idle
	var rand_state := randf()
	if rand_state > idle_walk_threshold:
		next_state = walk
	return next_state

