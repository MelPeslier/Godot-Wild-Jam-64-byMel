extends PlayerMove

@export var idle: State
@export var walk: State
@export var jump: State
@export var dash: State


func process_physics(delta: float) -> State:
	super(delta)
	parent.velocity.y += parent.fall_gravity * delta
	parent.move_and_slide()

	player.jump_buffer_timer -= delta
	player.dash_buffer_timer -= delta

	if parent.is_on_floor():
		# Is on floor and will change state, perfect moment to reset jumps
		player.alter_jumps(player.jumps_number)

		if player.jump_buffer_timer > 0 and player.can_jump():
			return jump
		if player.dash_buffer_timer > 0 and player.can_dash():
			return dash

		if get_movement_input():
			return walk
		else:
			return idle
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash():
		if player.can_dash():
			return dash
		player.dash_buffer_timer = player.dash_buffer_time

	if get_jump():
		if player.can_jump():
			return jump
		player.jump_buffer_timer = player.jump_buffer_time

	return null


func process_frame(_delta: float) -> State:
	return null
