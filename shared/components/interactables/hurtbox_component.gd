class_name HurtboxComponent
extends Area2D

@export var parent: Node2D

@export var health_component: HealthComponent
@export var knock_back_component: KnockBackComponent
@export var hit_stop_component: HitStopComponent


func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: HitboxComponent) -> void:
	if not hitbox:
		return

	if health_component:
		health_component.dammage(hitbox.damage)

	if knock_back_component:
		knock_back_component.update_knock_back()

	if hit_stop_component:
		hit_stop_component.update_hit_stop()
		return

	if parent:
		parent.just_got_hurt()
