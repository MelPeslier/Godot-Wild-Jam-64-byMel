class_name EnergyComponent
extends Node

signal energy_updated()

@export var max_energy: int
@export var start_energy: int

var energy: int:
	set(val):
		energy = clampi(val, 0, max_energy)
		energy_updated.emit()


func _ready() -> void:
	energy = start_energy


func have(energy_cost: int) -> bool:
	return energy_cost <= energy


func use(amount: int) -> void:
	energy -= amount


func gain(amount: int) -> void:
	energy += amount
