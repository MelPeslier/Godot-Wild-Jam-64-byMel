class_name RayCasts
extends Node2D

@export var parent: Player
@export_range(0, 30, 1) var margin: float
@export_range(0, 10) var transition_time: float
@export var use: bool

var tween: Tween

@onready var ray_y_left: RayCast2D = $ray_y_left
@onready var ray_y_mid: RayCast2D = $ray_y_mid
@onready var ray_y_right: RayCast2D = $ray_y_right

@onready var ray_bot_left: RayCast2D = $ray_bot_left
@onready var ray_bot_mid: RayCast2D = $ray_bot_mid
@onready var ray_bot_right: RayCast2D = $ray_bot_right

@onready var ray_x_up_1: RayCast2D = $ray_x_up_1
@onready var ray_x_up_2: RayCast2D = $ray_x_up_2
@onready var ray_x_mid: RayCast2D = $ray_x_mid
@onready var ray_x_bot_2: RayCast2D = $ray_x_bot_2
@onready var ray_x_bot_1: RayCast2D = $ray_x_bot_1


func _ready() -> void:
	deactivate()


func activate() -> void:
	if not use:
		return

	for ray: RayCast2D in get_children(true):
		if ray:
			ray.enabled = true


func deactivate() -> void:
	if not use:
		return

	for ray: RayCast2D in get_children(true):
		if ray:
			ray.enabled = false


func process_physics_up(_delta: float) -> void:
	if not use:
		return

	if not parent.old_velocity and parent.velocity.y < -5:
		if ray_y_left.is_colliding() and\
				not ray_y_mid.is_colliding() and\
				not ray_y_right.is_colliding():
			var dist: float = ray_y_mid.position.x - ray_y_left.position.x + margin
			go_y(dist)
		return

	if not parent.velocity.x:
		return

	if ray_y_left.is_colliding() and\
			ray_y_mid.is_colliding() and\
			not ray_y_right.is_colliding():
		var dist: float = ray_y_right.position.x - ray_y_mid.position.x + margin
		go_y(dist)

	elif ray_y_left.is_colliding() and\
			not ray_y_mid.is_colliding() and\
			not ray_y_right.is_colliding():
		var dist: float = ray_y_mid.position.x - ray_y_left.position.x + margin
		go_y(dist)


func process_physics_right(_delta: float) -> void:
	if not use:
		return

	if not parent.velocity.x:
		return

	if side_open():
		return

	if ray_x_up_1.is_colliding() and\
			not ray_x_bot_1.is_colliding() and\
			side_mid_open():
		var dist: float = ray_x_up_1.position.y - ray_x_up_2.position.y + margin
		go_x(dist)
		return

	if ray_x_bot_1.is_colliding() and\
			not ray_x_up_1.is_colliding() and\
			side_mid_open():
		var dist: float = ray_x_bot_1.position.y - ray_x_bot_2.position.y + margin
		go_x(dist)
		return


func go_x(dist: float) -> void:
	parent.global_position.y -= dist * sign(parent.velocity.y)
	parent.sprite.position.y += dist * sign(parent.velocity.y)
	come_back_x(dist)


func come_back_x(dist: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(parent.sprite, "position:y", parent.target_pos.position.y, transition_time)
		#.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func go_y(dist: float) -> void:
	parent.global_position.x += dist * scale.x
	parent.sprite.position.x -= dist * scale.x
	come_back_y(dist)


func come_back_y(dist: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(parent.sprite, "position:x", parent.target_pos.position.x, transition_time)
		#.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func up_open() -> bool:
	return not ray_y_left.is_colliding() and\
			not ray_y_mid.is_colliding() and\
			not ray_y_right.is_colliding()


func down_open() -> bool:
	return not ray_bot_left.is_colliding() and\
			not ray_bot_mid.is_colliding() and\
			not ray_bot_right.is_colliding()


func side_mid_open() -> bool:
	return not ray_x_up_2.is_colliding() and\
			not ray_x_mid.is_colliding() and\
			not ray_x_bot_2.is_colliding()


func side_open() -> bool:
	print("side_open")
	return  not ray_x_up_1.is_colliding() and\
			not ray_x_up_2.is_colliding() and\
			not ray_x_mid.is_colliding() and\
			not ray_x_bot_2.is_colliding() and\
			not ray_x_bot_1.is_colliding()
