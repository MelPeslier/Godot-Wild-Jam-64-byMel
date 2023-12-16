extends MoveState

@export_category("links")
@export var death_bringer: DeathBringer
@export var walk: State
@export var attack_holder: AttackHolder

@export_category("vars")
@export_range(0.2, 2) var state_time: float = 0.6
@export_range(0, 0.5) var state_time_rng: float = 0.1

var state_timer: float


func enter() -> void:
	super()
	attack_holder.activate()
	state_timer = state_time + randf_range(-state_time_rng, state_time_rng) * state_time


func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	parent.move_and_slide()

	state_timer -= delta
	if animated_sprite.is_playing() and animated_sprite.animation == animation_name: return null

	if not death_bringer.opponent or not death_bringer.fighting:
		death_bringer.fighting = false
		return walk

	if state_timer <= 0:
		death_bringer.make_decision()

	if not animated_sprite.is_playing():
		animated_sprite.play("idle")
	return null
