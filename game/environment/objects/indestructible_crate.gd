extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 1600 * delta

	velocity.x = lerpf(velocity.x, 0, 2 * delta)
	move_and_slide()


func _on_hit_received(kb: Vector2) -> void:
	if is_on_floor():
		velocity.y = 0
		kb.x = kb.x / 2.0
		kb.y = abs(kb.x) * -1.5
	velocity += kb


