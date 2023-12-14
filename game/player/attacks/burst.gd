extends EnergyAttack

@export var burst: State
@export var movement_state_machine: StateMachine

@onready var attack_scene: PackedScene = preload("res://shared/vfx/attacks/burst/burst_particles.tscn")


func _ready() -> void:
	super()
	attack_particles_scene = attack_scene


func play_attack() -> void:
	movement_state_machine.change_state(burst)
	super()
