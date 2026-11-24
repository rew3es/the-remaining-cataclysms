extends Node
class_name SwordDirection
var sword_logic: SwordLogic
func setup_logic(logic_ref: SwordLogic):
	sword_logic = logic_ref



func _mouse_possition_detect():
	var viewport = get_tree().root
	var mouse_position = viewport.get_mouse_position()
	var center = viewport.get_visible_rect().size / 2
	var direction = mouse_position - center 
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return "right"
		else: return "left"
	else:
		if direction.y > 0: 
			return "down"
		else: return "up"


func _attack_forward(type: String):
	match type:
		"fast": await sword_logic._general_attack("y", -15, -13.5, -150, 90, 10) # метод черезвычайно не абстрактный, и его пойму скорее всего только я 
		"powerful": await sword_logic._general_attack("y", -25, -13.5, -250, 90, 20)
func _attack_back(type: String):
	match type:
		"fast": await sword_logic._general_attack("y", 15, 13.5, 150, 90, 10)
		"powerful": await sword_logic._general_attack("y", 25, -13.5, 250, 90, 20)
func _attack_right(type: String):
	match type:
		"fast": await sword_logic._general_attack("x", 15, 0, 150, 90, 10)
		"powerful": await sword_logic._general_attack("x", 25, 0, 250, 90, 20)
func _attack_left(type: String):
	match type:
		"fast": await sword_logic._general_attack("x", -15, 0, -150, 90, 10)
		"powerful": await sword_logic._general_attack("x", -25, 0, -250, 90, 20)
