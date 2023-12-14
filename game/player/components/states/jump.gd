extends PlayerMove

@export var jump: State
@export var fall: State
@export var dash: State
@export var ray_casts: RayCasts

var want_jump := true

func enter() -> void:
	super()
	parent.velocity.y = -player.initial_jump_velocity * player.get_jump_coef()
	player.alter_jumps(-1)
	player.jump_time = 0
	want_jump = true


func process_physics(delta: float) -> State:
	player.jump_time += delta

	if not Input.is_action_pressed("jump"):
		want_jump = false

	if not( want_jump and player.jump_time < player.jump_time_to_peak) and\
			player.jump_time > player.min_jump_time:
		parent.velocity.y += player.fall_gravity * delta
	else:
		parent.velocity.y += player.gravity * delta
	ray_casts.process_physics_jump(delta)
	super(delta)
	parent.move_and_slide()

	if parent.velocity.y > 0:
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash() and player.can_dash():
		return dash
	if get_jump() and player.can_jump():
		return jump
	return null


func process_frame(_delta: float) -> State:
	return null
