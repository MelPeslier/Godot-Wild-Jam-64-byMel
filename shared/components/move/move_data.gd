class_name MoveData
extends Node

signal dir_changed(new_dir: int)

@export_category("test")
@export var test: bool: set =  _set_test

@export_category("walk")
@export_range(0, 2000, 1) var walk_distance: float = 400
@export_range(0, 3) var walk_accel_time: float = 0.125
@export_range(0, 3) var walk_decel_time: float = 0.2

@export_category("air")
@export_range(0.05, 100) var air_decel_time: float = 3

@export_category("jump")
@export_range(0, 2000, 1) var jump_height: float = 270
@export_range(0, 3) var jump_time_to_peak: float = 0.6
@export_range(0, 3) var jump_time_to_descent: float = 0.36
@export_range(0, 2000, 1) var max_fall_speed: float = 1200

@export_category("dash")
@export_range(0, 2000, 1) var dash_distance: float = 1024
@export_range(0.05, 1) var dash_time: float = 0.25

# Walk
var walk_accel: float
var walk_decel: float

# Air
var air_decel: float

# Jump
var initial_jump_velocity: float

# Gravity
var gravity: float
var fall_gravity: float

# Direction
var old_dir: int = 1
var dir: float = 1: set = _set_dir


func _ready() -> void:
	_update_data()
	set_process(test)


func _process(_delta: float) -> void:
	_update_data()


func _update_data() -> void:
	gravity = get_gravity(jump_height, jump_time_to_peak)
	fall_gravity = get_gravity(jump_height, jump_time_to_descent)
	initial_jump_velocity = get_velocity(jump_height, jump_time_to_peak)
	walk_decel = get_velocity(walk_distance, walk_decel_time)
	walk_accel = get_velocity(walk_distance, walk_accel_time)
	air_decel = get_velocity(walk_distance, air_decel_time)


#region Maths
func get_velocity(distance: float, time_to: float) -> float:
	return (2.0 * distance) / time_to

func get_gravity(distance: float, time_to: float) -> float:
	return ((2.0 * distance) / (time_to * time_to))
#endregion

#region Setters
func _set_test(new_val: bool) -> void:
	test = new_val
	set_process(test)

func _set_dir(new_dir: float) -> void:
	if new_dir == dir:
		return
	if new_dir == 0:
		dir = new_dir
		return
	old_dir = signi( int(new_dir) )
	dir = new_dir
	dir_changed.emit(dir)
#endregion
