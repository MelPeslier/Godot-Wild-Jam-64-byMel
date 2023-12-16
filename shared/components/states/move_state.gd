class_name MoveState
extends State


#region X vel
func do_walk_accelerate(delta: float) -> void:
	parent.velocity.x += move_data.dir * move_data.walk_accel * delta
	parent.velocity.x = move_data.dir * min( abs(parent.velocity.x), move_data.walk_distance )


func do_walk_decelerate(delta: float) -> void:
	if not (parent.velocity.x < 1.0 and parent.velocity.x > -1.0):
		parent.velocity.x = 0
		return
	var dir: float = sign(parent.velocity.x)
	var vel: float = abs(parent.velocity.x) - move_data.walk_decel * delta
	parent.velocity.x = dir * maxf(vel, 0)

#endregion

#region Hit
func do_hit(delta: float) -> void:
	do_air_decelerate(delta)
	do_gravity(delta)

func do_air_decelerate(delta: float) -> void:
	var vel_dir := signi( int(parent.velocity.x) )
	parent.velocity.x -= vel_dir * move_data.air_decel * delta
#endregion

#region Y vel
func do_gravity(delta: float) -> void:
	if parent.is_on_floor():
		parent.velocity.y = 0
		return
	if parent.velocity.y < 0:
		parent.velocity.y += move_data.gravity * delta
		return
	parent.velocity.y += move_data.fall_gravity * delta
	parent.velocity.y = minf(parent.velocity.y, move_data.max_fall_speed)

func do_jump() -> void:
	parent.velocity.y = - move_data.initial_jump_velocity
#endregion
