extends CharacterBody2D

@export var label: Label


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 1600 * delta

	velocity.x = lerpf(velocity.x, 0, 2 * delta)
	move_and_slide()


func _on_hit_received(kb: Vector2) -> void:
	if is_on_floor():
		velocity.y = 0
	velocity += kb


func _on_health_component_health_changed(_health: int, _max_health: int) -> void:
	label.text = " vie : %d " % [_health]
