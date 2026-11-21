extends Node2D
class_name sword
@onready var Hitbox_collision: Hitbox = $Hitbox
@export var character: AnimatedSprite2D
static var is_attack_now: bool = false
var can_attack: bool = true
func _ready() -> void:
	_disable(true)
	Hitbox_collision.global_position.y -= 50
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fast_attack_key") and  can_attack:
		is_attack_now = true
		character.stop()
		character.play("attack")
		can_attack = false
		_disable(false)
		#print("fast_attack")
		_move_hitbox()
		await get_tree().create_timer(0.5).timeout
		_disable(true)
		can_attack = true
		character.stop()
		is_attack_now = false
		
		
func _move_hitbox():
	var itt = 0
	while itt <= 10:
		Hitbox_collision.global_position.y -= 15
		Hitbox_collision.global_rotation_degrees -= 13.5
		await get_tree().process_frame
		itt += 1
	await get_tree().create_timer(0.1).timeout
	Hitbox_collision.global_position.y += 160
	Hitbox_collision.global_rotation_degrees = 90

func _disable(on_off: bool):
	if on_off:
		Hitbox_collision.monitorable = false
		Hitbox_collision.visible = false
	else: 
		Hitbox_collision.monitorable = true
		Hitbox_collision.visible = true
