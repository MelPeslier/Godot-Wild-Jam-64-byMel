class_name Soul
extends Node2D
@onready var animator: AnimationPlayer = $AnimationPlayer


var is_absorbed := false


func _ready() -> void:
	animator.play("elevate")



func disolve_me() -> void:
	if is_absorbed: return
	queue_free()


func go_to(_player: Player) -> void:
	is_absorbed = true


func _on_interactable_component_focused(_interactor: InteractorComponent) -> void:
	if not _interactor.controller: return
	if not _interactor.controller is Player: return

	go_to(_interactor.controller)
