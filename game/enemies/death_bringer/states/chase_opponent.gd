extends MoveState

@export_category("links")
@export var death_bringer: DeathBringer
@export var walk: State
@export var slash: State
@export var keep_range: State
@export var cast: State
@export var fall: State

@export_category("vars")
@export_range(100, 350, 1) var attack_range: float = 315
@export_range(1,2) var movement_coef: float = 1.2

@export_range(0.2, 10) var chase_time: float = 4.5
@export_range(0, 0.5) var chase_time_rng: float = 0.1

@export_range(0.2, 10) var no_movement_time: float = 1.5
@export_range(0, 0.5) var no_movement_time_rng: float = 0.1

@export_range(0.2, 2) var wall_time: float = 0.7
@export_range(0, 0.5) var wall_time_rng: float = 0.1

var no_movement_timer: float
var wall_timer: float
var chase_timer: float


func enter() -> void:
	super()
	chase_timer = chase_time + randf_range(-chase_time_rng, chase_time_rng) * chase_time
	wall_timer = wall_time + randf_range(-wall_time_rng, wall_time_rng) * wall_time
	no_movement_timer = no_movement_time + randf_range(-no_movement_time_rng, no_movement_time_rng) * no_movement_time


func process_physics(delta: float) -> State:
	if not death_bringer.opponent or not death_bringer.fighting:
		death_bringer.fighting = false
		return walk

	chase_timer -= delta
	if chase_timer <= 0:
		death_bringer.make_decision()

	var dist := death_bringer.global_position.distance_to(death_bringer.opponent.global_position)
	var diff := death_bringer.global_position - death_bringer.opponent.global_position
	if -10 < diff.x and diff.x < 10 and diff.y > 100:
		if not animated_sprite.animation == "idle":
			animated_sprite.play("idle")
		move_data.dir = 0
		no_movement_timer -= delta
		if no_movement_timer < 0:
			if death_bringer.can_cast():
				return cast
	else:
		if not animated_sprite.animation == animation_name:
			animated_sprite.play(animation_name)
		var dir_x := death_bringer.global_position.direction_to( death_bringer.opponent.global_position ).x
		move_data.dir = 1 if dir_x > 0 else -1
	do_walk_accelerate(delta)
	parent.move_and_slide()
	if not parent.is_on_floor():
		return fall
	if dist < attack_range:
		if death_bringer.can_slash():
			return slash

	if parent.is_on_wall():
		wall_timer -= delta
		if wall_timer <= 0:
			return keep_range

	return null


func do_walk_accelerate(delta: float) -> void:
	parent.velocity.x += move_data.dir * move_data.walk_accel * movement_coef * delta
	parent.velocity.x = move_data.dir * min( abs(parent.velocity.x), move_data.walk_distance * movement_coef )
