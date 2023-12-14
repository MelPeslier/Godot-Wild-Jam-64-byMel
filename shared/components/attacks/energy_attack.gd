class_name EnergyAttack
extends Attack

@export var energy_component: EnergyComponent
@export_range(0, 10) var energy_cost: int


func _ready() -> void:
	super()
	energy_component.energy_updated.connect(_on_energy_updated)
	can_attack = energy_component.have(energy_cost)


func _on_timer_timeout() -> void:
	if energy_component.have(energy_cost):
		can_attack = true


func play_attack() -> void:
	super()
	energy_component.use(energy_cost)


func _on_energy_updated() -> void:
	if not timer.time_left > 0.0:
		can_attack = energy_component.have(energy_cost)

