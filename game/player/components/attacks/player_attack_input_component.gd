extends AttackInputComponent

@export var player: Player
@export var can_attack_while_dash:= true


func wants_basic_attack() -> bool:
	return Input.is_action_just_pressed("basic_attack")


func wants_special_attack_1() -> bool:
	return Input.is_action_just_pressed("special_attack_1")


func wants_special_attack_2() -> bool:
	return Input.is_action_just_pressed("special_attack_2")


func wants_attack() -> bool:
	return wants_basic_attack() or wants_special_attack_1() or wants_special_attack_2()


func can_attack() -> bool:
	match player.current_movement_state:
		Player.MovementState.DASH:
			return can_attack_while_dash

	return true
