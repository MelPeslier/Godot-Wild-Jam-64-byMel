extends PlayerMove

@export var jump: State
@export var fall: State
@export var dash: State
@export var ray_casts: RayCasts

@export_category("light_particles")
@export var light_particles_number: int
@export var light_particles_sphere_size: float
@export var light_particles_lifetime: float
@export var light_particles_explosiveness: float

var light_particles_scene: PackedScene = preload("res://shared/vfx/light_particles/light_particles.tscn")
var step_light_particles_scene: PackedScene = preload("res://shared/vfx/steps/step_light.tscn")

var want_jump := true


func enter() -> void:
	super()
	if not parent.is_on_floor():
		spawn_step_light(player.get_jump_coef())
	spawn_light_particles(player.get_jump_coef())
	parent.velocity.y = -player.initial_jump_velocity * player.get_jump_coef()
	player.alter_jumps(-1)
	player.jump_time = 0
	want_jump = true
	ray_casts.activate()


func exit() -> void:
	ray_casts.deactivate()


func process_physics(delta: float) -> State:
	player.jump_time += delta

	if not Input.is_action_pressed("jump"):
		want_jump = false

	if not( want_jump and player.jump_time < player.jump_time_to_peak) and\
			player.jump_time > player.min_jump_time:
		parent.velocity.y += player.fall_gravity * delta
	else:
		parent.velocity.y += player.gravity * delta
	ray_casts.process_physics_up(delta)
	ray_casts.process_physics_right(delta)
	super(delta)
	parent.move_and_slide()

	if parent.velocity.y > 0:
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash() and player.can_dash():
		return dash
	if get_jump() and player.can_jump():
		return jump
	return null


func process_frame(_delta: float) -> State:
	return null


func spawn_step_light(coef: float) -> void:
	var step_instance: StepLight = step_light_particles_scene.instantiate() as StepLight
	parent.add_child(step_instance)
	step_instance.play(coef)


func spawn_light_particles(coef: float) -> void:
	var light_instance: LightParticles = light_particles_scene.instantiate() as LightParticles
	parent.add_child(light_instance)
	var number := int (light_particles_number * coef)
	light_instance.play(number, light_particles_sphere_size, light_particles_lifetime, light_particles_explosiveness)
