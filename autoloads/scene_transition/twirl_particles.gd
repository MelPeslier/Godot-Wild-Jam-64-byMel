extends GPUParticles2D

@onready var animator: AnimationPlayer = $Animator

func _ready() -> void:
	animator.play("START")


func stop() -> void:
	animator.play_backwards("START")
