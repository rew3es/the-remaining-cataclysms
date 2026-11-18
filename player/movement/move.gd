class_name player_move
extends CharacterBody2D
@export var speed = 500  #скорость игрока - 300 едениц
@export var character: Sprite2D
static var direction: Vector2
var sprite_direction: Vector2
func _physics_process(delta: float) -> void:
	direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)
	sprite_direction = Input.get_vector(
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
static func move(frames: int, speed: int, tree: SceneTree, player: CharacterBody2D):
	var frame: int = 1
	direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)
	while frame <= frames:
		player.velocity = direction * speed
		player.move_and_slide()
		await tree.process_frame
		frame += 1
	
