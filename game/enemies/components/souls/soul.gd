class_name Soul
extends Node2D

@export_range(0, 4000) var distance: float = 700
@export_range(0, 10) var speed_to_sky: float = 5
@export_range(0, 10) var speed_to_target: float = 1.8

var tween: Tween
var end_pos: Vector2
var normal := true

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var soul: GPUParticles2D = $soul
@onready var accel: GPUParticles2D = $accel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func init() -> void:
	animator.play("appear")
	end_pos = global_position + Vector2(0, -distance)
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", end_pos, speed_to_sky)
	tween.tween_interval(1.5)
	tween.tween_callback(animation_player.play.bind("disapear"))


func go_to(_player: Player) -> void:
	if tween or tween.is_running():
		tween.kill()

	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", _player.global_position, speed_to_target)
	tween.parallel().tween_callback(animation_player.play.bind("absorb"))
	tween.parallel().tween_callback(_player.health_component.heal.bind( randi_range(1, 5) ) )
	tween.parallel().tween_callback(_player.energy_component.gain.bind( randi_range(1, 3) ) )
	tween.tween_callback(queue_free)


func _on_interactable_component_area_entered(area: Area2D) -> void:
	if not area is InteractorComponent: return
	var _interactor: InteractorComponent = area as InteractorComponent
	if not _interactor.parent: return
	if not _interactor.parent is Player: return
	go_to(_interactor.parent)
