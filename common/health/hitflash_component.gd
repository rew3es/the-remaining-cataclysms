class_name HitflashComponent
extends Node

@export var hurtbox: HurtboxComponent
@export var target_sprite: CanvasItem
@export var flash_color: Color = Color(1.0, 0.2, 0.2, 1.0) # Ярко-красный оттенок
@export var flash_duration: float = 0.15

var _tween: Tween

func _ready() -> void:
	if hurtbox:
		hurtbox.hit_received.connect(_on_hit_received)

func _on_hit_received(_attack: AttackData) -> void:
	if not target_sprite:
		return
		
	if _tween and _tween.is_valid():
		_tween.kill()
		
	target_sprite.modulate = flash_color
	
	_tween = create_tween()
	_tween.tween_property(target_sprite, "modulate", Color.WHITE, flash_duration)
