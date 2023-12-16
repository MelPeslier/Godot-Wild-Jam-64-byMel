class_name EnemyMoveInputComponent
extends MoveInputComponent

@export_range(0, 1) var left_right_tendency: float = 0.5


func get_movement_direction() -> float:
	var pos := randf()
	if pos > left_right_tendency :
		return 1.0
	return -1.0
