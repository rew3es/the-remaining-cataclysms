extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
