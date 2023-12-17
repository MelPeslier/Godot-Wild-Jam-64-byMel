extends MoveState

@export_category("links")
@export var death_bringer: DeathBringer
@export var walk: State
@export var die: State
@export var slash: State

@export_category("vars")
@export_range(0.01, 2) var state_time: float = 0.05
@export_range(0, 0.5) var state_time_rng: float = 0.0

var state_timer: float


func enter() -> void:
	super()
	state_timer = state_time + randf_range(-state_time_rng, state_time_rng) * state_time


func process_physics(delta: float) -> State:
	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()
	state_timer -= delta
	if animated_sprite.is_playing(): return null

	if death_bringer.health_component.health == 0:
		return die

	if not death_bringer.opponent or not death_bringer.fighting:
		death_bringer.fighting = false
		return walk

	if state_timer <= 0:
		if death_bringer.can_slash():
			return slash
		death_bringer.make_decision()

	animated_sprite.play("idle")
	return null


# Listening HurtboxComponent
func _on_hit_received(kb: Vector2) -> void:
	if death_bringer.state_machine.current_state == die:
		return
	death_bringer.state_machine.change_state(self)
	parent.velocity = kb
