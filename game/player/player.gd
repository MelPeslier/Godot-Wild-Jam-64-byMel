class_name Player
extends CharacterBody2D

enum MovementState{
	IDLE,
	DASH,
	JUMP,
	WALK,
	FALL,
	BURST,
	FINISHER,
	HIT,
	DIE
}

@export var movement_state_machine: StateMachine
@export var movement_animator: AnimationPlayer
@export var player_movement_component: MovementComponent
@export var attacks: PlayerAttacks

@export_category("jump")
@export_range(0, 2000, 1) var max_fall_speed: float = 1
@export_range(0, 1) var min_jump_coef: float = 1
@export_range(0, 2000, 1) var jump_height: float = 1
@export_range(0, 3) var jump_time_to_peak: float = 0.5
@export_range(0, 3) var jump_time_to_descent: float = 0.4
@export var jumps_number: int = 1
@export var next_jumps_coef: float
@export var jump_buffer_time: float
@export var jump_coyote_time: float

@export_category("walk")
@export_range(0, 2000, 1) var walk_speed: float = 1
@export_range(0, 2) var walk_acceleration_time: float = 1
@export_range(0, 2) var walk_deceleration_time: float = 1

@export_category("dash")
@export var dashes_number: int = 1
@export_range(0.05, 1) var dash_buffer_time: float = 0.1
@export_range(0.05, 3) var dash_interval_time: float = 0.5
@export_range(0, 2000, 1) var dash_speed: float = 1024
@export_range(0.05, 1) var dash_time: float = 0.3

@export_category("attacks")
@export_range(0.05, 5) var finisher_time: float
@export_range(0.05, 5) var burst_time: float

var current_movement_state: MovementState

var gravity: float = 0
var fall_gravity: float = 0
var initial_jump_velocity: float = 0

var walk_acceleration: float = 0
var walk_deceleration: float = 0

var remaining_jumps: int = jumps_number
var jump_buffer_timer: float = 0
var jump_time: float = 0
var min_jump_time: float = 0

var remaining_dashes: int = dashes_number
var dash_interval_timer: float = 0:
	set(val):
		dash_interval_timer = maxf(val, 0)
var dash_buffer_timer: float = 0
var dash_timer: float = 0

var can_move: bool = true
var old_direction: int = 1
var old_velocity: float = 0

var finisher_timer: float
var burst_timer: float


func _ready() -> void:
	update_physics_data()
	movement_state_machine.init(self, movement_animator, player_movement_component)


func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_unhandled_input(event)
	attacks.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	#FIXME remove it, it's only here to tweak values in editor and to see changes in real-time
	update_physics_data()

	dash_interval_timer -= delta
	if is_on_floor() and dash_interval_timer == 0:
		reload_dashes()

	movement_state_machine.process_physics(delta)
	attacks.process_physics(delta)


func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)


#region Movement functions
func can_dash() -> bool:
	return remaining_dashes > 0 and can_move

func alter_dashes(val: int) -> void:
	remaining_dashes = clampi(remaining_dashes + val, 0, dashes_number)

func reload_dashes() -> void:
	alter_dashes(dashes_number)


func can_jump() -> bool:
	return remaining_jumps > 0 and can_move

func alter_jumps(val: int) -> void:
	remaining_jumps = clampi(remaining_jumps + val, 0, jumps_number)

func get_jump_coef() -> float:
	return 1.0 - next_jumps_coef * ( jumps_number - remaining_jumps )
#endregion


#region Physics
func update_physics_data() -> void:
	gravity = Math.get_gravity(jump_height, jump_time_to_peak)
	fall_gravity = Math.get_gravity(jump_height, jump_time_to_descent)
	initial_jump_velocity = Math.get_velocity(jump_height, jump_time_to_peak)
	walk_deceleration = Math.get_velocity(walk_speed, walk_deceleration_time)
	walk_acceleration = Math.get_velocity(walk_speed, walk_acceleration_time)
	min_jump_time = jump_time_to_peak * min_jump_coef
#endregion

