class_name AfterHitEffectComponent
extends Node

var hit_stop: float:
	set(val):
		hit_stop = maxf(val, 0)

var hit_stop_shake: float
var knock_back: float
var camera_shake: float


func just_got_hit(_knock_back: float, _hit_stop: float, _hit_stop_shake: float, _camera_shake: float) -> void:
	hit_stop = _hit_stop
	hit_stop_shake = _hit_stop_shake
	knock_back = _knock_back
	camera_shake = _camera_shake
