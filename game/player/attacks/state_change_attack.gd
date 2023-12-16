extends EnergyAttack

@export var state_machine: StateMachine
@export var state: State


func play_attack() -> void:
	super()
	state_machine.change_state(state)
