class_name PlayerAttacks
extends Node2D

@export var player: Player
@export var attack_input_component: AttackInputComponent
@export var attack_data: AttackData

@export_category("Attacks")
@export var attack_pattern_1 :Array[Attack]
@export var attack_pattern_2 :Array[Attack]
@export var finisher: Attack
@export var burst: Attack

@export_category("Intervals")
@export_range(0.05, 2) var combo_time: float = 0.75
@export_range(0.05, 2) var attack_interval_time: float = 0.5
@export_range(0.05, 2) var attack_buffer_time: float = 0.4

var pattern: Array[Array]
var pattern_index: int = 0
var attack_index: int = 0

var combo_timer: float:
	set(val):
		combo_timer = maxf(-0.1, val)

var attack_interval_timer: float:
	set(val):
		attack_interval_timer = maxf(-0.1, val)

var attack: Attack
var is_basic_attack := false


func _ready() -> void:
	pattern = [attack_pattern_1, attack_pattern_2]
	for _attack: Attack in get_children():
		if _attack:
			_attack.parent = player
			_attack.attack_data = attack_data


func process_physics(delta: float) -> void:
	combo_timer -= delta
	attack_interval_timer -= delta

	if attack_interval_timer > 0:
		if attack_interval_timer - attack_buffer_time > 0:
			attack = null
		return

	if not attack: return
	if not attack_input_component.can_attack():
		return

	if is_basic_attack:
		# Switch to next attack if in conbo time
		if combo_timer > 0:
			attack_index = (attack_index + 1) % (pattern[pattern_index].size())
			# When we finish a pattern, we switch to the other pattern
			if attack_index == 2:
				pattern_index = (pattern_index + 1) % (pattern.size())

		else:
			attack_index = 0

		attack = pattern[pattern_index][attack_index]
		combo_timer = combo_time

	# We attack !

	attack_interval_timer = attack_interval_time
	attack.play_attack()
	attack = null


func process_unhandled_input(_event: InputEvent) -> void:
	if attack_input_component.wants_special_attack_1() and finisher.can_attack:
		attack = finisher
		is_basic_attack = false

	if attack_input_component.wants_special_attack_2() and burst.can_attack:
		attack = burst
		is_basic_attack = false

	if attack_input_component.wants_basic_attack():
		is_basic_attack = true
		attack = pattern[pattern_index][attack_index]

