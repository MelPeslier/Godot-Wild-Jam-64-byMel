class_name AttackManager
extends Node2D

@export var parent: Node2D
@export var attack_input_component: AttackInputComponent
@export var attack_data: AttackData

@export_category("Intervals")
@export_range(0.05, 2) var attack_interval_time: float

var attack_interval_timer: float: set = _set_attack_interval_timer
var attack: AttackHolder


func _ready() -> void:
	for _attack: AttackHolder in get_children():
		if _attack:
			_attack.parent = parent
			_attack.attack_data = attack_data


func process_physics(delta: float) -> void:
	attack_interval_timer -= delta
	if attack_interval_timer > 0:
		attack = null
		return

	if not attack: return
	if not attack_input_component.can_attack():
		return
	attack_interval_timer = attack_interval_time
	attack.activate()
	attack = null


func _set_attack_interval_timer(new_val: float) -> void:
	attack_interval_timer = maxf(0, new_val)
