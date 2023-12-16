extends MoveInputComponent

func get_movement_direction() -> float:
	return Input.get_axis('move_left', 'move_right')


func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")


func wants_dash() -> bool:
	return Input.is_action_just_pressed("dash")

