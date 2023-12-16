class_name PlayerState
extends MoveState

@export var player_movement_state: Player.MovementState

var player: Player

func _ready() -> void:
	parent_update.connect(_on_parent_update, CONNECT_ONE_SHOT)


func _on_parent_update() -> void:
	player = parent


func enter() -> void:
	super()
	player.current_movement_state = player_movement_state


func get_movement_input() -> float:
	return move_input_component.get_movement_direction()


func get_jump() -> bool:
	return move_input_component.wants_jump()


func get_dash() -> bool:
	return move_input_component.wants_dash()
