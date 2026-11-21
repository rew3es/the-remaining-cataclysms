class_name Hurtbox
extends Area2D

signal hurt(damage: int, knockback_direction: Vector2, knockback_force: float)

@export var invincibility_duration: float = 0.5

var is_invincible: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	await get_tree().physics_frame
	for area in get_overlapping_areas(): # get_overlapping_areas возвращает список пересекающих area2D
		_on_area_entered(area)
	
func _on_area_entered(area: Area2D) -> void:
	if is_invincible or not (area is Hitbox):
		return
		
	var knockback_dir: Vector2 = (global_position - area.global_position).normalized()
	
	hurt.emit(area.damage, knockback_dir, area.knockback_force)
	
	if invincibility_duration > 0.0:
		_start_invincibility()
		
func _start_invincibility() -> void:
	is_invincible = true
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
