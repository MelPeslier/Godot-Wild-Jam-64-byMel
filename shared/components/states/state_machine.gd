class_name StateMachine
extends Node

@export var starting_state: State

var current_state: State


func init(parent: CharacterBody2D, animator: AnimationPlayer, movement_component: MovementComponent) -> void:
	for child : State in get_children():
		child.parent = parent
		child.animator = animator
		child.movement_component = movement_component

	change_state(starting_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

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
	var new_state := current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

