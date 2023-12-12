extends Node

const E := 0.001


func calc_gravity(height: float, distance: float, velocity_x: float) -> float:
	return (2 * height * pow(velocity_x, 2) ) / ( pow(distance, 2) )


func calc_initial_jump_velocity(height: float, distance: float, velocity_x: float) -> float:
	return ( 2 * height * velocity_x ) / ( distance )


func get_velocity(jump_height: float, jump_time_to_peak: float) -> float:
	return (2.0 * jump_height) / jump_time_to_peak


func get_gravity(jump_height: float, jump_time_to_peak: float) -> float:
	return ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
