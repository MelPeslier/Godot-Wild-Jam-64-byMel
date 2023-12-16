extends PlayerState

@export var idle: State
@export var walk: State
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
var dash_particles_scene: PackedScene = preload("res://shared/vfx/dash/dash_particles.tscn")


func enter() -> void:
	super()
	player.alter_dashes(-1)
	spawn_particles()
	player.dash_timer = move_data.dash_time
	player.dash_interval_timer = player.dash_interval_time
	parent.velocity.y = 0
	ray_casts.activate()


func exit() -> void:
	ray_casts.deactivate()


func process_physics(delta: float) -> State:
	parent.velocity.x = move_data.dash_distance * move_data.old_dir
	ray_casts.process_physics_right(delta)
	parent.move_and_slide()

	player.jump_buffer_timer -= delta
	player.dash_buffer_timer -= delta
	player.dash_timer -= delta

	if player.dash_timer > 0:
		return null

	if parent.is_on_floor():
		player.alter_jumps(player.jumps_number)

		if player.jump_buffer_timer > 0 and player.can_jump():
			return jump
		if player.dash_buffer_timer > 0 and player.can_dash():
			return dash

		if get_movement_input():
			return walk
		return idle

	else:
		# Can jump right after the end of dash if jump availbale
		if player.jump_buffer_timer > 0 and player.can_jump():
			return jump

	return fall


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash():
		player.dash_buffer_timer = player.dash_buffer_time

	if get_jump():
		player.jump_buffer_timer = player.jump_buffer_time

	return null


func process_frame(_delta: float) -> State:
	return null


func spawn_particles() -> void:
	var dash_instance: DashParticles = dash_particles_scene.instantiate()
	parent.add_child(dash_instance)
	dash_instance.position = player.mid_pos.position
	dash_instance.play(move_data.old_dir)

	var light_instance: LightParticles = light_particles_scene.instantiate() as LightParticles
	parent.add_child(light_instance)
	light_instance.position = player.mid_pos.position
	light_instance.play(light_particles_number, light_particles_sphere_size, light_particles_lifetime, light_particles_explosiveness)
