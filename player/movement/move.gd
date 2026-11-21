class_name player_move
extends CharacterBody2D
@export var speed = 500  #скорость игрока - 300 едениц
@export var character: AnimatedSprite2D
static var direction: Vector2
var sprite_direction: Vector2
func _ready() -> void:
	character.play("idle")
func _physics_process(delta: float) -> void:
	direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)
	velocity = direction * speed
	if Input.is_action_pressed("move_player_left") or Input.is_action_pressed("move_player_right") or Input.is_action_pressed("move_player_back") or Input.is_action_pressed("move_player_forward"):
		if !sword.is_attack_now:
			character.play("walk")
	else:
		if !sword.is_attack_now:
			character.play("idle")
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
	
