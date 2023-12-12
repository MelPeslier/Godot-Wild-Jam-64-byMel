extends PlayerMove

@export var idle: State
@export var jump: State
@export var fall: State
@export var dash: State


func process_physics(delta: float) -> State:
	if not get_movement_input() or not player.can_move:
		return idle

	super(delta)
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash() and player.can_dash():
		return dash
	if get_jump() and player.can_jump():
		return jump
	return null
