extends Node
class_name player_config

# в этом файле все основные экспорты. 

#общее

@export var character_animate_sprite: AnimatedSprite2D


#рывок из скрипта "res://player/movement/dash.gd"
@export var dash_speed = 1500
@export var dash_frames = 10 #количество кадров которое будет совершаться рывок
@export var dash_cooldown: float = 0.5
@export var is_camera_position_smoothing_enabled = true
@export var camera_position_smoothing_speed = 3
@export var SwordDirection_script: String = "res://player/player_logic/sword/sword_direction.gd"
#передвижение из скрипта "res://player/movement/move.gd"

@export var move_speed = 500
