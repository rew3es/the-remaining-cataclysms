class_name player_move
extends CharacterBody2D
@onready var speed = PLAYER_CONFIG.move_speed  #скорость игрока - 500 едениц
@export var character: AnimatedSprite2D
static var is_dashing: bool = false
static var direction: Vector2

static var keybinds_controls = {
	"w": "move_player_forward",
	"a": "move_player_left",
	"s": "move_player_back",
	"d": "move_player_right",
}
var sprite_direction: Vector2
func _ready() -> void:
	character.play("idle")
func _physics_process(_delta: float) -> void:
	if is_dashing:
		return
	direction = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	)
	velocity = direction * speed
	if Input.is_action_pressed("move_player_left") or Input.is_action_pressed("move_player_right") or Input.is_action_pressed("move_player_back") or Input.is_action_pressed("move_player_forward"):
		if !Sword.is_attack_now:
			character.play("walk")
	else:
		if !Sword.is_attack_now:
			character.play("idle")
	move_and_slide()
	

static func _mouse_direction(player: CharacterBody2D) -> Vector2:
	var mouse_position = player.get_global_mouse_position()
	var direction_move = mouse_position - player.global_position
	return direction_move.normalized()

static func move(frames: int, speed_2: int, tree: SceneTree, player: CharacterBody2D, direction_mouse: bool):
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
