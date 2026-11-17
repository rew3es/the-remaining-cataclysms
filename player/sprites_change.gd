extends Node
class_name sprite_change
@export var sprite: Sprite2D


static var textures = {
	"front": preload("res://player/temp_sprite/temp_character_forward.png"),
	"back": preload("res://player/temp_sprite/temp_character_back.png"),
	"left": preload("res://player/temp_sprite/temp_character_left.png"),
	"right": preload("res://player/temp_sprite/temp_character_right.png")
}

static func set_direction(sprite: Sprite2D, direction: String):
	sprite.texture = textures[direction]
	
func _ready() -> void:
	sprite.texture = textures["front"]
