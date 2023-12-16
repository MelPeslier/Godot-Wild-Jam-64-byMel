class_name DeathBringer
extends CharacterBody2D

@export var state_machine: StateMachine
@export var animator: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var move_input_component: MoveInputComponent
@export var move_data: MoveData
@export var health_component: HealthComponent

# UtilityAI
@export_category("UtilityAI")
@export_range(0.0, 1.0) var vary_behavior: float
@export var max_distance_to_opponent: float
@export var needs: DeathBringerNeeds
@export var chase_opponent_state: State
@export var keep_range_state: State

# UtilityAI
var fighting := false: set = _set_fighting
var opponent: Node2D

# UtilityAI
@onready var _options: Array[UtilityAIOption] = [
	UtilityAIOption.new(
		preload("res://game/enemies/death_bringer/utility_ai/behaviors/chase_opponent.tres"), needs, chase_opponent
	),
	UtilityAIOption.new(
		preload("res://game/enemies/death_bringer/utility_ai/behaviors/keep_range.tres"), needs, keep_range
	)
]

@onready var detector_component: DetectorComponent = $"2DComponents/DetectorComponent"
@onready var attack_manager: AttackManager = $"2DComponents/AttackManager"
@onready var spell_holder: AttackHolder = $"2DComponents/AttackManager/SpellHolder" as AttackHolder
@onready var slash_holder: AttackHolder = $"2DComponents/AttackManager/SlashHolder" as AttackHolder

# Debug
@onready var labels_container: VBoxContainer = $Panel/HBoxContainer/UtilityAiDebugPanelLabels
@onready var utility_score: Label = $Panel/HBoxContainer/UtilityAiDebugPanel/utility_score
@onready var distance_to_opponent: Label = $Panel/HBoxContainer/UtilityAiDebugPanel/distance_to_opponent
@onready var health: Label = $Panel/HBoxContainer/UtilityAiDebugPanel/health
@onready var opponent_health: Label = $Panel/HBoxContainer/UtilityAiDebugPanel/opponent_health
@onready var spell_damage: Label = $Panel/HBoxContainer/UtilityAiDebugPanel/spell_damage
@onready var slash_damage: Label = $Panel/HBoxContainer/UtilityAiDebugPanel/slash_damage


func _ready() -> void:
	state_machine.init(self, animator, animated_sprite, move_input_component, move_data)
	attack_manager.init(self)
	for label : Label in labels_container.get_children():
		label.text = label.name


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	attack_manager.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)

	# UtilityAI
	if not opponent:
		return

	if not fighting:
		var op: Player = opponent as Player
		print("want disconnect")
		op.health_component.health_changed.disconnect(_on_opponent_health_changed)
		opponent = null
		detector_component.disable.call_deferred(false)
		return

	if opponent:
		var dist := global_position.distance_to(opponent.global_position)
		needs.distance_to_opponent = remap(dist, 0.0, max_distance_to_opponent, 0.0, 1.0)

		# Debug
		distance_to_opponent.text = " %.3f" % needs.distance_to_opponent
		health.text = str(needs.health)
		opponent_health.text = str(needs.opponent_health)
		spell_damage.text = str(needs.spell_damage)
		slash_damage.text = str(needs.slash_damage)



func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_unhandled_input(event)


func _on_move_data_dir_changed(new_dir: int) -> void:
	animated_sprite.flip_h = new_dir >= 0
	if new_dir > 0:
		animated_sprite.offset.x = 39
		attack_manager.scale.x = 1
	else:
		animated_sprite.offset.x = -33
		attack_manager.scale.x = -1


func can_cast() -> bool:
	return spell_holder.can_attack

func can_slash() -> bool:
	return slash_holder.can_attack


#region UtilityAI Functions
# Activate fight mode, and update all UtilityaI related data
func _on_detector_component_area_entered(area: Area2D) -> void:
	if not area.parent is Player: return
	opponent = area.parent as Player
	fighting = true

	# Connect health to needs
	opponent.health_component.health_changed.connect(_on_opponent_health_changed)
	opponent.health_component.damage(0)
	var dist := global_position.distance_to(opponent.global_position)

	# Give distance to needs (will do in looop in process)
	needs.distance_to_opponent = remap(dist, 0.0, max_distance_to_opponent, 0.0, 1.0)

	# Update needs attack dammage (already connected via signal)
	for attack_holder: AttackHolder in attack_manager.get_children():
		attack_holder.can_attack = true

	#enable fight mode, disable this collision zone and make a decision
	detector_component.disable.call_deferred(true)
	make_decision()


func make_decision() -> void:
	var decision := UtilityAI.choose_highest(_options, vary_behavior)
	utility_score.text = str(decision.action.get_method())
	decision.action.call()


func chase_opponent() -> void:
	state_machine.change_state(chase_opponent_state)


func keep_range() -> void:
	state_machine.change_state(keep_range_state)


func _on_health_changed(_health: int,  _max_health: int) -> void:
	needs.health = remap(_health, 0, _max_health, 0, 1)


func _on_opponent_health_changed(_health: int, _max_health: int) -> void:
	needs.opponent_health = remap(_health, 0, _max_health, 0, 1)


func _on_spell_holder_attack_up(_can_attack: bool, _damage: int) -> void:
	if not opponent:
		return
	var damage: float = 0.0
	if _can_attack:
		var op: Player = opponent as Player
		damage = remap(float(_damage), 0.0, float(op.health_component.max_health), 0.0, 1.0)
	needs.spell_damage = damage


func _on_slash_holder_attack_up(_can_attack: bool, _damage: int) -> void:
	if not opponent:
		return
	var damage: float = 0.0
	if _can_attack:
		var op: Player = opponent as Player
		damage = remap(float(_damage), 0.0, float(op.health_component.max_health), 0.0, 1.0)
	needs.slash_damage = damage
#endregion


func _set_fighting(_do_fight: bool) -> void:
	if _do_fight == fighting: return
	if not _do_fight:
		opponent = null
	fighting = _do_fight





