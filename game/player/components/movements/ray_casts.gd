class_name RayCasts
extends Node2D

@export var parent: Player
@export_range(0, 30, 1) var margin: float
@export_range(0, 10) var transition_time: float

var tween: Tween

@onready var ray_y_left: RayCast2D = $ray_y/ray_y_left
@onready var ray_y_mid: RayCast2D = $ray_y/ray_y_mid
@onready var ray_y_right: RayCast2D = $ray_y/ray_y_right

@onready var ray_x_up_1: RayCast2D = $ray_x/ray_x_up_1
@onready var ray_x_up_2: RayCast2D = $ray_x/ray_x_up_2
@onready var ray_x_mid: RayCast2D = $ray_x/ray_x_mid
@onready var ray_x_bot_2: RayCast2D = $ray_x/ray_x_bot_2
@onready var ray_x_bot_1: RayCast2D = $ray_x/ray_x_bot_1


func process_physics_jump(_delta: float) -> void:
	print(".target_pos : ", parent.target_pos.position, parent.target_pos.global_position)
	print(".target_pos : ", parent.target_pos.position, parent.target_pos.global_position)
	print("sprite : ", parent.sprite.position, parent.sprite.global_position)
	print("sprite : ", parent.sprite.position, parent.sprite.global_position)
	# Jump and move
	# si on saute mais qu'on ne bouge pas
	if not parent.old_velocity and parent.velocity.y < -5:
		if ray_y_left.is_colliding() and\
				not ray_y_mid.is_colliding() and\
				not ray_y_right.is_colliding():
			var dist: float = ray_y_mid.position.x - ray_y_left.position.x + margin
			print("ray_casts:process_physics")
			go_y(dist)


func go_y(dist: float) -> void:
	print(dist)
	parent.global_position.x += dist * scale.x
	parent.sprite.position.x -= dist * scale.x
	come_back_y()


func come_back_y() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(parent.sprite, "position:y", parent.target_pos.position.y + 7, transition_time*0.05)
	tween.tween_property(parent.sprite, "position:x", parent.target_pos.position.x, transition_time * 0.5)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(parent.sprite, "position:y", parent.target_pos.position.y, transition_time*0.9)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)



func side_open() -> bool:
	print("side_open")
	return  not ray_x_up_1.is_colliding() and\
			not ray_x_up_2.is_colliding() and\
			not ray_x_mid.is_colliding() and\
			not ray_x_bot_2.is_colliding() and\
			not ray_x_bot_1.is_colliding()
