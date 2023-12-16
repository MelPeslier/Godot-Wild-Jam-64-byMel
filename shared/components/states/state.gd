class_name State
extends Node

signal parent_update()

var parent: CharacterBody2D:
	set(new_value):
		parent = new_value
		parent_update.emit()

var animator: AnimationPlayer
var animated_sprite: AnimatedSprite2D
var move_input_component: MoveInputComponent
var move_data: MoveData

@onready var animation_name: String = name


func enter() -> void:
	animator.play(animation_name)
	animated_sprite.play(animation_name)


func exit() -> void:
	pass


func process_physics(_delta: float) -> State:
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	return null


func process_frame(_delta: float) -> State:
	return null


func get_movement_input() -> float:
	return move_input_component.get_movement_direction()


func get_jump() -> bool:
	return move_input_component.wants_jump()


func get_dash() -> bool:
	return move_input_component.wants_dash()
