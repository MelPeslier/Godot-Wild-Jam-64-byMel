class_name InteractorComponent
extends Area2D

@export var parent: Node2D


func _init() -> void:
	collision_layer = 4
	collision_mask = 0


func interact(interactable: InteractableComponent) -> void:
	interactable.interacted.emit(self)


func focus(interactable: InteractableComponent) -> void:
	interactable.focused.emit(self)


func unfocus(interactable: InteractableComponent) -> void:
	interactable.unfocused.emit(self)


func get_closest_interactable() -> InteractableComponent:
	var list: Array[Area2D] = get_overlapping_areas()
	var distance: float
	var closest_distance: float = INF
	var closest: InteractableComponent = null

	for interactable: InteractableComponent in list:
		distance = interactable.global_position.distance_to(global_position)

		if distance < closest_distance:
			closest = interactable
			closest_distance = distance

	return closest
