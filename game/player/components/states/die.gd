extends PlayerState

@export var soul_scene: PackedScene

func enter() -> void:
	super()
	player.disable_attack()
	player.disable_input()
	GameManager.player_died()


func spawn_soul() -> void:
	var soul_instance: Soul = soul_scene.instantiate() as Soul
	get_window().add_child(soul_instance)
	soul_instance.global_position = parent.global_position
	soul_instance.init()


func back() -> void:
	SceneTransition.change_scene("res://ui/menus/menu.tscn")
