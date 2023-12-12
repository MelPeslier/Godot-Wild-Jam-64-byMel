extends InteractorComponent

var cached_closest: InteractableComponent


func _ready() -> void:
	area_exited.connect(_on_area_exited)


func process_physics(_delta: float) -> void:
	var new_closest: InteractableComponent = get_closest_interactable()
	if new_closest != cached_closest:
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
		if new_closest:
			focus(new_closest)
	cached_closest = new_closest


func process_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_instance_valid(cached_closest):
			interact(cached_closest)


func _on_area_exited(_area: InteractableComponent) -> void:
	if cached_closest == _area:
		unfocus(_area)


func reset_cached_closest() -> void:
#	cached_closest
	cached_closest = null
