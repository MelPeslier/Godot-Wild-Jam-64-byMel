extends PlayerState

@export var idle: State
@export var walk: State
@export var jump: State
@export var fall: State
@export var dash: State


func enter() -> void:
	super()
	player.alter_dashes(-1)
	player.dash_timer = player.dash_time
	parent.velocity.y = 0


func process_physics(delta: float) -> State:
	parent.velocity.x = player.dash_speed * player.old_direction
	parent.move_and_slide()

	player.jump_buffer_timer -= delta
	player.dash_buffer_timer -= delta
	player.dash_timer -= delta

	if player.dash_timer > 0:
		return null

	if parent.is_on_floor():
		player.alter_jumps(player.jumps_number)
		player.reload_dashes()
		if player.jump_buffer_timer > 0 and player.can_jump():
			return jump
		if player.dash_buffer_timer > 0 and player.can_dash():
			return dash

		if get_movement_input():
			return walk
		return idle

	else:
		# Can jump right after the end of dash if jump availbale
		if player.jump_buffer_timer > 0 and player.can_jump():
			return jump

	return fall


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash():
		player.dash_buffer_timer = player.dash_buffer_time

	if get_jump():
		player.jump_buffer_timer = player.jump_buffer_time

	return null


func process_frame(_delta: float) -> State:
	return null
