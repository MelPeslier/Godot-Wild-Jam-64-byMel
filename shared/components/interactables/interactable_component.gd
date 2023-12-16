class_name InteractableComponent
extends Area2D

signal focused(_interactor: InteractorComponent)

signal unfocused(_interactor: InteractorComponent)

signal interacted(_interactor: InteractorComponent)


func _init() -> void:
	collision_layer = 4
	collision_mask = 0
