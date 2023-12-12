extends AudioStreamPlayer


enum CrossFade {
	NONE,
	CROSS,
	OUT_IN
}

enum Fade {
	NONE,
	OUT,
	IN
}

const MIN_LINEAR := 0.001

@export var fade_in_time: float = 6
@export var fade_out_time: float = 3
@export var cross_fade_in_time: float = 3
@export var cross_fade_out_time: float = 3
@export var bus_name: String = "Music"

@onready var dummy_player := AudioStreamPlayer.new()


func _ready() -> void:
	bus = bus_name
	add_child(dummy_player)
	dummy_player.bus = bus_name


# ****************** #
#  PUBLIC functions  #
# ****************** #


func change_sound(_new_song_path: String, _cross_fade: CrossFade = CrossFade.CROSS) -> void:
	match _cross_fade:
		CrossFade.NONE:
			_change_sound(_new_song_path)

		CrossFade.CROSS:
			var tween: Tween = create_tween().set_parallel()

			var new_audio_stream: AudioStream = load(_new_song_path)
			if new_audio_stream == null:
				print("can't load NEW audio file")
				return
			dummy_player.stream = new_audio_stream
			dummy_player.volume_db = -60
			dummy_player.play()
			_fade_in(tween, cross_fade_out_time, dummy_player)
			_fade_out(tween, cross_fade_in_time, self)
			tween.chain().tween_callback(_update_stream_player)

		CrossFade.OUT_IN:
			var tween: Tween = create_tween()
			_fade_out(tween, fade_out_time)
			tween.tween_callback(_change_sound.bind(_new_song_path))
			_fade_in(tween, fade_in_time)


func _update_stream_player() -> void:
	volume_db = dummy_player.volume_db
	stream = dummy_player.stream
	play(dummy_player.get_playback_position())
	dummy_player.stop()


func fade_sound(_fade: Fade) -> void:
	var tween: Tween = create_tween()
	match _fade:
		Fade.OUT:
			_fade_out(tween, fade_out_time)

		Fade.IN:
			_fade_in(tween, fade_in_time)


# ******************* #
#  PRIVATE functions  #
# ******************* #


func _change_sound(_new_song_path: String) -> void:
	var audio_stream: AudioStream = load(_new_song_path)
	if audio_stream == null:
		print("can't load audio file")
		return
	stream = audio_stream
	play()


func _fade_out(_tween: Tween, speed: float, asp: AudioStreamPlayer = self) -> void:
	_tween.tween_method(_set_volume.bind(asp), db_to_linear(asp.volume_db), MIN_LINEAR, speed)


func _fade_in(_tween: Tween, speed: float, asp: AudioStreamPlayer = self) -> void:
	_tween.tween_method(_set_volume.bind(asp), MIN_LINEAR, db_to_linear(0), speed)


func _set_volume(val: float, asp: AudioStreamPlayer = self) -> void:
	asp.volume_db = linear_to_db(val)
