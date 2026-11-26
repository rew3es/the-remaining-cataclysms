extends Camera2D

@export var player: CharacterBody2D

func _ready() -> void:
	position_smoothing_enabled = PLAYER_CONFIG.is_camera_position_smoothing_enabled
	position_smoothing_speed = PLAYER_CONFIG.camera_position_smoothing_speed

func _process(delta: float) -> void:
	if player_move.is_mooving_now:
			global_position = player.global_position
