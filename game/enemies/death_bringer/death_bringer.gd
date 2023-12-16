extends CharacterBody2D

@export var state_machine: StateMachine
@export var animator: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var move_input_component: MoveInputComponent
@export var move_data: MoveData
@export var health_component: HealthComponent

# UtilityAI
@export_category("UtilityAI")
@export var max_distance_to_opponent: float
@export var needs: AgentNeeds

# UtilityAI
var fighting := false
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

@onready var attack_manager: AttackManager = $"2DComponents/AttackManager"
@onready var timer := Timer.new()


func _ready() -> void:
	state_machine.init(self, animator, animated_sprite, move_input_component, move_data)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(2)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)

	# UtilityAI
	if not fighting:
		opponent = null
		return

	if opponent:
		var dist := global_position.distance_to(opponent.global_position)
		needs.distance_to_opponent = remap(dist, 0, max_distance_to_opponent, 0.0, 1.0)



func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_unhandled_input(event)


func _on_move_data_dir_changed(new_dir: int) -> void:
	animated_sprite.flip_h = new_dir >= 0
	if new_dir > 0:
		animated_sprite.offset.x = 39
	else:
		animated_sprite.offset.x = -33


func _on_detector_component_area_entered(area: Area2D) -> void:
	if not area.parent is Player: return
	opponent = area.parent
	for attack_holder: AttackHolder in attack_manager.get_children():
		var attack_instance: AttackParticles = attack_holder.attack_scene.instantiate()
		print(attack_instance)
		attack_instance.queue_free()

	fighting = true


#region UtilityAI Functions
func _on_timer_timeout() -> void:
	var decision := UtilityAI.choose_highest(_options, 0.1)
	decision.action.call()
	health_component.damage(1)


func chase_opponent() -> void:
	print("chase")

func keep_range() -> void:
	print("keep_range")

func melee_attack() -> void:
	print("melee_attack")

func spell_attack() -> void:
	print("spell_attack")


func _on_health_changed(_health: int,  _max_health: int) -> void:
	needs.health = remap(_health, 0, _max_health, 0, 1)


func _on_opponent_health_changed(_opponent_health: int, _opponent_max_health: int) -> void:
	needs.opponent_health = remap(_opponent_health, 0, _opponent_max_health, 0, 1)
#endregion





