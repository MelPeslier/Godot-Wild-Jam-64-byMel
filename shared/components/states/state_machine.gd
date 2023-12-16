class_name StateMachine
extends Node

@export var starting_state: State

var old_state: State
var current_state: State


func init(parent: CharacterBody2D, \
		animator: AnimationPlayer, \
		animated_sprite: AnimatedSprite2D, \
		move_input_component: MoveInputComponent, \
		move_data: MoveData
	) -> void:
	for state : State in get_children():
		state.parent = parent
		state.animator = animator
		state.animated_sprite = animated_sprite
		state.move_input_component = move_input_component
		state.move_data = move_data

	change_state(starting_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	old_state = current_state
	current_state = new_state
	current_state.enter()


func process_physics(delta: float) -> void:
	var new_state := current_state.process_physics(delta)
	if new_state:
		change_state(new_state)


func process_unhandled_input(event: InputEvent) -> void:
	var new_state := current_state.process_unhandled_input(event)
	if new_state:
		change_state(new_state)


func process_frame(delta: float) -> void:
	var new_state := current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

