class_name player_dash

extends Node
var player: CharacterBody2D
var can_dash: bool = true

func _ready():
	await get_tree().process_frame
	player = get_tree().current_scene.get_node("sort_object/player")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("player_dash") and can_dash:
			can_dash = false
			player_move.move(10, 1000, get_tree(), player)
			
			await get_tree().create_timer(0.5).timeout # meta чтобы игрок не злоупотреблял рывком
			can_dash = true
