class_name PlayerMove
extends PlayerState


func process_physics(delta: float) -> State:
	if not player.can_move: return null
	var direction := get_movement_input()

	if direction:
		parent.velocity.x += direction * player.walk_acceleration * delta
		parent.velocity.x = direction * min(abs(parent.velocity.x), player.walk_speed)
		player.old_velocity = abs(parent.velocity.x)
		player.old_direction = sign(direction)
	else:
		parent.old_velocity -= player.walk_deceleration * delta
		parent.old_velocity = max(parent.old_velocity, 0)
		parent.velocity.x = parent.old_velocity * parent.old_direction

	if player.velocity.y > 0 :
		player.velocity.y = minf(player.velocity.y, player.max_fall_speed)

	return null

