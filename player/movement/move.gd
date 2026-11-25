class_name player_move
extends Node
@export var Player: CharacterBody2D
@onready var speed = PLAYER_CONFIG.move_speed  #скорость игрока - 500 едениц
@export var player_animation: AnimatedSprite2D
@onready var is_dashing: bool = false
@onready var direction: Vector2

@onready var keybinds_controls = {
	"w": "move_player_forward",
	"a": "move_player_left",
	"s": "move_player_back",
	"d": "move_player_right",
}
var sprite_direction: Vector2

func _physics_process(_delta: float) -> void:
	if is_dashing:
		return
	direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)
	Player.velocity = direction * speed
	
	Player.move_and_slide()
	


func _mouse_direction(player: CharacterBody2D) -> Vector2:
	var mouse_position = player.get_global_mouse_position()
	var direction_move = mouse_position - player.global_position
	return direction_move.normalized()

func move(frames: int, speed_2: int, tree: SceneTree, player: CharacterBody2D, direction_mouse: bool):
	is_dashing = true
	var frame: int = 1

	if !direction_mouse:
		direction = Input.get_vector(
			keybinds_controls["a"], keybinds_controls["d"],
			keybinds_controls["w"], keybinds_controls["s"]
		)
	else: direction = _mouse_direction(player)
		

	while frame <= frames:
		player.velocity = direction * speed_2
		player.move_and_slide()
		frame += 1
		await tree.physics_frame
	is_dashing = false
