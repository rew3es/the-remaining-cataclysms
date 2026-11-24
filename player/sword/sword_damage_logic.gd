extends Node
class_name SwordLogic

const SwordDirectionPreload = preload("res://player/sword/sword_direction.gd")
@onready var sword_direction = SwordDirection.new()
@onready var sword = get_parent()
@onready var Hitbox_collision: CollisionShape2D = get_parent().get_node("Hitbox/CollisionShape2D")
@onready var hitbox: Hitbox = get_parent().get_node("Hitbox")
var is_attack_now: bool = false
var can_attack: bool = true

signal character_stop_animation()
signal character_switch_animation_to_attack()


func _ready() -> void:
	var start_direction = SwordDirectionPreload.new()
	add_child(start_direction)
	add_child(sword_direction)
	sword_direction.setup_logic(self)
	
	_disable(true)
	sword.sword_attacked.connect(_attack_registrated)

func _start_attack():
	is_attack_now = true
	can_attack = false
	character_switch_animation_to_attack.emit()
func _stop_attack(): 
	can_attack = true
	is_attack_now = false
	character_stop_animation.emit()
	

func _attack_registrated(attack_type):
	match attack_type:
		Sword.Attack_type.FAST: print("FAST")
		Sword.Attack_type.POWERFUL: print("POWERFUL")

func _disable(on_off: bool):
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
