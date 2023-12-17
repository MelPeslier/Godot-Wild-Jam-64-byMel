extends PlayerState

@export var idle: State
@export var die: State

var is_dead := false

func enter() -> void:
	super()
	player.disable_attack()
	player.disable_input()


func exit() -> void:
	player.enable_attack()
	player.enable_input()


func process_physics(delta: float) -> State:
	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()

	if animator.is_playing():
		return null

	if is_dead:
		return die

	return idle

# Listening HurtboxComponent
func _on_hit_received(kb: Vector2) -> void:
	player.movement_state_machine.change_state(self)
	parent.velocity = kb


func _on_health_component_health_changed(_health: int, _max_health: int) -> void:
	print("new_health : ", _health)
	if _health == 0:
		is_dead = true
