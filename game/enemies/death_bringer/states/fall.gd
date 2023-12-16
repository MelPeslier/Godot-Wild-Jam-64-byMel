extends MoveState

@export var idle: State
@export var death_bringer: DeathBringer

func process_physics(delta: float) -> State:
	do_gravity(delta)
	if move_data.dir != 0:
		do_walk_accelerate(delta)
	else:
		do_air_decelerate(delta)
	parent.move_and_slide()
	if parent.is_on_floor():
		if not death_bringer.opponent or not death_bringer.fighting:
			death_bringer.fighting = false
			return idle
		death_bringer.make_decision()

	return null
