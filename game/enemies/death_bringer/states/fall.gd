extends MoveState

@export var idle: State


func process_physics(delta: float) -> State:
	do_gravity(delta)
	if move_data.dir != 0:
		do_walk_accelerate(delta)
	else:
		do_air_decelerate(delta)
	parent.move_and_slide()
	if parent.is_on_floor():
		return idle
	return null
