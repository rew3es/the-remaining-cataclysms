class_name player_move
extends CharacterBody2D
@export var speed = 300  #скорость игрока - 300 едениц
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)

	velocity = direction * speed
	move_and_slide()
