extends Node
class_name SwordLogic
static var is_attack_now: bool = false
var can_attack: bool = true
const SwordDirectionPreload = preload("res://player/sword/sword_direction.gd")

@onready var sword_direction = SwordDirection.new()
@onready var sword = get_parent()
@onready var Hitbox_collision: CollisionShape2D = get_parent().get_node("Hitbox/CollisionShape2D")
@onready var hitbox: Hitbox = get_parent().get_node("Hitbox")
@onready var character := get_tree().current_scene.get_node("sort_object/player/AnimatedSprite2D")

func _ready() -> void:
	var start_direction = SwordDirectionPreload.new()
	add_child(start_direction)
	add_child(sword_direction)
	sword_direction.setup_logic(self)
	
	_disable(true)
	sword.sword_attacked.connect(_attack_registrated)

func _start_attack():
	is_attack_now = true
	character.stop()
	can_attack = false
	character.play("attack")
	
func _stop_attack(): 
	can_attack = true
	character.stop()
	is_attack_now = false
	
func _general_attack(transform_component: String, transform_position: int, transform_position_degree: float, transform_position_return: int,  transform_rotation_degree_return: float, frame_value: int):
	var itt = 1
	var varalignment: float = 10.0 / frame_value
	while itt <= frame_value:
		if(transform_component == "x"): Hitbox_collision.global_position.x += transform_position * varalignment
		elif(transform_component == "y"): Hitbox_collision.global_position.y += transform_position * varalignment
		Hitbox_collision.global_rotation_degrees += transform_position_degree * varalignment
		await get_tree().process_frame
		itt += 1
	await get_tree().create_timer(0.1).timeout
	if(transform_component == "x"): Hitbox_collision.global_position.x -= transform_position_return
	elif(transform_component == "y"): Hitbox_collision.global_position.y -= transform_position_return
	Hitbox_collision.global_rotation_degrees = transform_rotation_degree_return 

func _attack_registrated(attack_type):
	match attack_type:
		Sword.Attack_type.FAST: print("FAST")
		Sword.Attack_type.POWERFUL: print("POWERFUL")

func _disable(on_off: bool):
	if on_off:
		Hitbox_collision.set_deferred("disabled", on_off)
		Hitbox_collision.visible = not on_off
	else: 
		Hitbox_collision.set_deferred("disabled", on_off)
		Hitbox_collision.visible = not on_off

func _move_hitbox(type: String):
	match sword_direction._mouse_possition_detect(): 
		"right": await sword_direction._attack_right(type)
		"left": await sword_direction._attack_left(type)
		"down": await sword_direction._attack_back(type)
		"up": await sword_direction._attack_forward(type) 
func _attack_procces(type: String):
	_start_attack()
	_disable(false)
	if type == "fast":
		await _move_hitbox("fast")
	if type == "powerful":
		await _move_hitbox("powerful")
	_disable(true)
	if type == "fast": await get_tree().create_timer(0.2).timeout
	elif type == "powerful": await get_tree().create_timer(0.3).timeout
	_stop_attack()
