extends PlayerMove

@export var walk: State
@export var jump: State
@export var fall: State
@export var dash: State


func process_physics(delta: float) -> State:
	super(delta)
	parent.move_and_slide()

	if !parent.is_on_floor():
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_movement_input() and player.can_move:
		return walk
	if get_jump() and player.can_jump():
		return jump
	if get_dash() and player.can_dash():
		return dash
	return null
