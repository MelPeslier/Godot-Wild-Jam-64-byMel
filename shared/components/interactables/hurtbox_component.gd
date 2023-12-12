class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent


func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: HitboxComponent) -> void:
	if not hitbox:
		return

	if health_component:
		health_component.hit(hitbox.damage)

	if hitbox:
		return

	if hitbox:
		return
