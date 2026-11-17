class_name player_move
extends CharacterBody2D
@export var speed = 300  #скорость игрока - 300 едениц
@export var character: Sprite2D
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)
	var sprite_direction = Input.get_vector(
		"move_player_left", "move_player_right", "move_player_forward", "move_player_back"
	)

	match sprite_direction:
		Vector2.LEFT:
			print("Идём влево")
			sprite_change.set_direction(character, "left")
		Vector2.RIGHT:
			print("Идём вправо")
			sprite_change.set_direction(character, "right")
		Vector2.UP:
			print("Идём вперёд")
			sprite_change.set_direction(character, "front")
		Vector2.DOWN:
			print("Идём назад")
			sprite_change.set_direction(character, "back")
		
	velocity = direction * speed
	move_and_slide()
