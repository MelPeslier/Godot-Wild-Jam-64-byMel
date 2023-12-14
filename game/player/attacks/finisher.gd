extends EnergyAttack

@export var finisher: State
@export var movement_state_machine: StateMachine

@onready var attack_scene: PackedScene = preload("res://shared/vfx/attacks/finisher/finisher_particles.tscn")


func _ready() -> void:
	super()
	attack_particles_scene = attack_scene


func play_attack() -> void:
	super()
	movement_state_machine.change_state(finisher)
