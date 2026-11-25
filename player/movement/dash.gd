class_name player_dash
extends Node

@export var player: CharacterBody2D
var can_dash: bool = true
@onready var dash_speed = PLAYER_CONFIG.dash_speed
@onready var dash_frames = PLAYER_CONFIG.dash_frames
@onready var dash_cooldown: float = PLAYER_CONFIG.dash_cooldown
@export var move_component: Node

func _ready():
	await get_tree().process_frame

func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_pressed("player_dash") and can_dash:
		await _start_dash(dash_frames)
		_stop_dash()
		
func _start_dash(frames: int):
	can_dash = false
	move_component.move(frames, dash_speed, get_tree(), player, false) # false означает что рывок совершается по направлению движения, а не мыши, если интересно узнать больше то поставь true
func _stop_dash():
	await get_tree().create_timer(dash_cooldown).timeout # meta чтобы игрок не злоупотреблял рывком
	can_dash = true
