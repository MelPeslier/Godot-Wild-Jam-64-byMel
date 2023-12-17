extends CanvasLayer



func _on_play_pressed() -> void:
	Sfx.play_sfx(Sfx.Sounds.CLICK_MAIN)
	SceneTransition.change_scene("res://game/levels/level_000_test.tscn")
	Music.change_sound("res://shared/sound/Era of Vampires/Dead_Village_Loop.wav")


func _on_quitter_pressed() -> void:
	get_tree().quit()
