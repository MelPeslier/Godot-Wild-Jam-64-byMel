class_name HurtboxComponent
extends Area2D

signal hit_received(kb: Vector2)

@export var receiver_data: AttackData
@export var parent: Node2D
@export var health_component: HealthComponent


func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: HitboxComponent) -> void:
	if not hitbox:
		return
	if hitbox.parent == parent:
		return

	var kb: Vector2 = hitbox.parent.global_position.direction_to(global_position) * hitbox.knock_back
	var dm: int = hitbox.damage

	if hitbox.attack_data and receiver_data:
		if hitbox.attack_data.owner_type == receiver_data.owner_type:
			return

		# Special interactions depending on types

	if health_component:
		health_component.damage(dm)

	hit_received.emit(kb)
