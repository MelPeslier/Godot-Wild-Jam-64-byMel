@tool
extends Node

enum Sounds {
	OVER,
	CLICK_MAIN,
	SCROLL
}

@export var sound_list : Array[AudioStream]
@export var bus_name: String

@onready var audio_stream_player := AudioStreamPlayer.new()


func _ready() -> void:
	audio_stream_player.bus = bus_name


func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray = []
	var tab = "\n      + "

	if sound_list.size() == 0:
		warning.push_back("No sound :")
		warning[-1] += tab + "Add sounds in the export list."

	if sound_list.size() < Sounds.size():
		warning.push_back("There is less sounds than enum options :")
		warning[-1] += tab + "Add sounds in the export list."
		warning[-1] += tab + "Remove enum options from the script."

	elif sound_list.size() > Sounds.size():
		warning.push_back("There is more sounds than enum options :")
		warning[-1] += tab + "Add enum options in the script."
		warning[-1] += tab + "Remove some sound from the export list."

	return warning


func play(audio_stream: AudioStream) -> void:
	var asp := audio_stream_player.duplicate()
	asp.stream = audio_stream
	asp.finished.connect(_on_play_finished.bind(asp))
	add_child(asp)
	asp.play()


func play_sfx(sound: Sounds) -> void:
	play(sound_list[sound])


func _on_play_finished(asp: AudioStreamPlayer) -> void:
	asp.queue_free()
