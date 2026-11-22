extends Node2D
class_name sword
@onready var Hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@export var character: AnimatedSprite2D
static var is_attack_now: bool = false
var can_attack: bool = true
func _ready() -> void:
	_disable(true)
func _input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("fast_attack_key") and can_attack and not event.is_echo():
			_attack_procces()
			
func _attack_procces():
	_start_attack()
	_disable(false)
	await _move_hitbox()
	await get_tree().create_timer(0.5).timeout
	_disable(true)
	_stop_attack()

func _start_attack():
	is_attack_now = true
	character.stop()
	can_attack = false
	character.play("attack")
	
func _stop_attack():
	can_attack = true
	character.stop()
	is_attack_now = false
	
func _move_hitbox():
	match _mouse_possition_detect():
		"right": await _attack_right()
		"left": await _attack_left()
		"down": await _attack_back()
		"up": await _attack_forward()

func _mouse_possition_detect():
	var mouse_possition = get_viewport().get_mouse_position() # вектор позиции мышки 
	var center = get_viewport_rect().size / 2 # векторп центра экрана
	var direction = mouse_possition - center # где мышь
	if abs(direction.x) > abs(direction.y): # если модуль координаты мышки по х больше модуля координаты мышки по y (просто смотрим, находится ли мышь ближе к боку экрана чем к низу или верху)
		if direction.x > 0: # мышь справа
			return "right"
		else: return "left"
	else:
		if direction.y > 0: # мышь справа
			return "down"
		else: return "up"
	

	
func _attack_forward():
	await _general_attack("y", -15, -13.5, -160, 90)
func _attack_back():
	await _general_attack("y", 15, 13.5, 160, 90)
func _attack_right():
	await _general_attack("x", 15, 0, 160, 90)
func _attack_left():
	await _general_attack("x", -15, 0, -160, 90)
	
func _general_attack(transform_component: String, transform_position: int, transform_position_degree: float, transform_position_return: int,  transform_rotation_degree_return: float):
	var itt = 0
	while itt <= 10:
		if(transform_component == "x"): Hitbox_collision.global_position.x += transform_position
		elif(transform_component == "y"): Hitbox_collision.global_position.y += transform_position
		Hitbox_collision.global_rotation_degrees += transform_position_degree
		await get_tree().process_frame
		itt += 1
	await get_tree().create_timer(0.1).timeout
	if(transform_component == "x"): Hitbox_collision.global_position.x -= transform_position_return
	elif(transform_component == "y"): Hitbox_collision.global_position.y -= transform_position_return
	Hitbox_collision.global_rotation_degrees = transform_rotation_degree_return


func _disable(on_off: bool):
	if on_off:
		Hitbox_collision.set_deferred("disabled", on_off)
		Hitbox_collision.visible = not on_off
	else: 
		Hitbox_collision.set_deferred("disabled", on_off)
		Hitbox_collision.visible = not on_off
