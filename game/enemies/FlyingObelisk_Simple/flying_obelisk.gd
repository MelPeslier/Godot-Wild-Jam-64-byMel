class_name FlyingObelisk
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream: AudioStream = preload("res://game/enemies/FlyingObelisk_Simple/win.mp3")


func _on_interactable_component_area_entered(area: Area2D) -> void:
	if not area is InteractorComponent: return
	var i: InteractorComponent = area as InteractorComponent
	if i.parent is Player:
		Sfx.play(audio_stream)
		SceneTransition.change_scene("res://ui/menus/menu.tscn")
