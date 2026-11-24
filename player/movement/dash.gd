class_name player_dash
extends Node

var player: CharacterBody2D
var can_dash: bool = true

@onready var dash_speed = PLAYER_CONFIG.dash_speed
@onready var dash_frames = PLAYER_CONFIG.dash_frames
@onready var dash_cooldowm: float = PLAYER_CONFIG.dash_cooldowm

func _ready():
	await get_tree().process_frame
	player = get_tree().current_scene.get_node("sort_object/player")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_pressed("player_dash") and can_dash:
		await _start_dash(dash_frames)
		_stop_dash()
		
func _start_dash(frames: int):
	can_dash = false
	player_move.move(frames, dash_speed, get_tree(), player, false) # false означает что рывок совершается по направлению движения, а не мыши, если интересно узнать больше то поставь true
func _stop_dash():
	await get_tree().create_timer(dash_cooldowm).timeout # meta чтобы игрок не злоупотреблял рывком
	can_dash = true
