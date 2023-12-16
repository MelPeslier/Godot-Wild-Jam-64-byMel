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

@export_category("Components & Nodes")
@export var movement_state_machine: StateMachine
@export var movement_animator: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var move_input_component: MoveInputComponent
@export var health_component: HealthComponent
@export var move_data: MoveData

@export_category("jump")
@export_range(0, 1) var min_jump_coef: float = 0.35
@export var jumps_number: int = 2
@export var next_jumps_coef: float = 0.25
@export var jump_buffer_time: float = 0.1
@export var jump_coyote_time: float = 0.1

@export_category("dash")
@export var dashes_number: int = 1
@export_range(0.05, 1) var dash_buffer_time: float = 0.15
@export_range(0.05, 3) var dash_interval_time: float = 1

@export_category("attacks")
@export_range(0.05, 8) var finisher_time: float = 8
@export_range(0.05, 5) var burst_time: float = 3.5

@export_category("hit")
@export_range(0.05, 8) var hit_timer: float = 0.1

var current_movement_state: MovementState

var remaining_jumps: int = jumps_number
var jump_buffer_timer: float = 0
var jump_time: float = 0
var min_jump_time: float = 0
var jump_coyote_timer: float = 0

var remaining_dashes: int = dashes_number
var dash_interval_timer: float = 0:
	set(val):
		dash_interval_timer = maxf(val, 0)

var dash_buffer_timer: float = 0
var dash_timer: float = 0

var finisher_timer: float
var burst_timer: float

var can_move: bool = true
var _can_attack := true
var _can_receive_input := true

@onready var attacks: PlayerAttacks = $"2DComponents/Attacks"
@onready var ray_casts: Node2D = $"2DComponents/RayCasts"
@onready var bot_pos: Marker2D = $bot_pos
@onready var mid_pos: Marker2D = $mid_pos


func _ready() -> void:
	movement_state_machine.init(self, movement_animator, animated_sprite, move_input_component, move_data)
	min_jump_time = move_data.jump_time_to_peak * min_jump_coef


func _unhandled_input(event: InputEvent) -> void:
	if not can_receive_input(): return
	movement_state_machine.process_unhandled_input(event)
	attacks.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	# Dash
	dash_interval_timer -= delta
	if is_on_floor() and dash_interval_timer == 0:
		reload_dashes()

	movement_state_machine.process_physics(delta)
	attacks.process_physics(delta)


func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)


#region Can do
func can_attack() -> bool:
	return _can_attack and _can_receive_input

func disable_attack() -> void:
	_can_attack = false

func enable_attack() -> void:
	_can_attack = true

func can_receive_input() -> bool:
	return _can_receive_input

func disable_input() -> void:
	_can_receive_input = false

func enable_input() -> void:
	_can_receive_input = true
#endregion


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


#region Signals Connected
func _on_move_data_dir_changed(new_dir: int) -> void:
	animated_sprite.flip_h = new_dir < 0
	attacks.scale.x = float( new_dir )
	ray_casts.scale.x = float( new_dir )
	mid_pos.scale.x = float( new_dir )
	bot_pos.scale.x = float( new_dir )
#endregion
