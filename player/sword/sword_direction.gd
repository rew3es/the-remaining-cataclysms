extends Node
class_name SwordDirection
var sword_logic: SwordLogic
var hitbox_collision: CollisionShape2D
func setup_logic(logic_ref: SwordLogic):
	hitbox_collision = logic_ref.Hitbox_collision
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

func _general_attack(transform_component: String, transform_position: int, transform_position_degree: float, transform_position_return: int,  transform_rotation_degree_return: float, frame_value: int):
	var itt = 1
	var varalignment: float = 10.0 / frame_value
	while itt <= frame_value:
		if(transform_component == "x"): hitbox_collision.global_position.x += transform_position * varalignment
		elif(transform_component == "y"): hitbox_collision.global_position.y += transform_position * varalignment
		hitbox_collision.global_rotation_degrees += transform_position_degree * varalignment
		await get_tree().process_frame
		itt += 1
	await get_tree().create_timer(0.1).timeout
	if(transform_component == "x"): hitbox_collision.global_position.x -= transform_position_return
	elif(transform_component == "y"): hitbox_collision.global_position.y -= transform_position_return
	hitbox_collision.global_rotation_degrees = transform_rotation_degree_return 



func _attack_forward(type: String):
	match type:
		"fast": await _general_attack("y", -15, -13.5, -150, 90, 10) 
		"powerful": await _general_attack("y", -25, -13.5, -250, 90, 20)
func _attack_back(type: String):
	match type:
		"fast": await _general_attack("y", 15, 13.5, 150, 90, 10)
		"powerful": await _general_attack("y", 25, -13.5, 250, 90, 20)
func _attack_right(type: String):
	match type:
		"fast": await _general_attack("x", 15, 0, 150, 90, 10)
		"powerful": await _general_attack("x", 25, 0, 250, 90, 20)
func _attack_left(type: String):
	match type:
		"fast": await _general_attack("x", -15, 0, -150, 90, 10)
		"powerful": await _general_attack("x", -25, 0, -250, 90, 20)
