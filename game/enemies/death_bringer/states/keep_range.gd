extends MoveState

@export_category("links")
@export var death_bringer: DeathBringer
@export var idle: State
@export var chase_opponent: State
@export var cast: State
@export var fall: State

@export_category("vars")
@export_range(100, 700, 1) var min_attack_range: float = 630
@export_range(100, 2000, 1) var max_attack_range: float = 1260
@export_range(1,2) var movement_coef: float = 1.2

@export_range(0.2, 2) var wall_time: float = 0.9
@export_range(0, 0.5) var wall_time_rng: float = 0.1

@export_range(0.2, 10) var state_time: float = 3.5
@export_range(0, 0.5) var state_time_rng: float = 0.1

var state_timer: float
var wall_timer: float


func enter() -> void:
	super()
	state_timer = state_time + randf_range(-state_time_rng, state_time_rng) * state_time
	wall_timer = wall_time + randf_range(-wall_time_rng, wall_time_rng) * wall_time


func process_physics(delta: float) -> State:
	if not death_bringer.opponent or not death_bringer.fighting:
		death_bringer.fighting = false
		return idle

	state_timer -= delta
	if state_timer <= 0:
		death_bringer.make_decision()

	var dist := death_bringer.global_position.distance_to(death_bringer.opponent.global_position)
	var dir_x := death_bringer.global_position.direction_to( death_bringer.opponent.global_position ).x
	move_data.dir = 1 if dir_x > 0 else -1
	do_walk_accelerate(delta)
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall

	if dist > min_attack_range and dist < max_attack_range:
		if death_bringer.can_cast():
			return cast

	if parent.is_on_wall():
		wall_timer -= delta
		if wall_timer <= 0:
			return chase_opponent

	return null


func do_walk_accelerate(delta: float) -> void:
	parent.velocity.x += -1.0 * move_data.dir * move_data.walk_accel * movement_coef * delta
	parent.velocity.x = -1.0 * move_data.dir * min( abs(parent.velocity.x), move_data.walk_distance * movement_coef )
