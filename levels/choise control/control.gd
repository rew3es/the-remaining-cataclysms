extends Node
func _ready() -> void:
	$CenterContainer/VBoxContainer/mouse.pressed.connect(_mouse_selected)
	$CenterContainer/VBoxContainer/no_mouse.pressed.connect(_no_mouse_selected)
	

func _mouse_selected() -> void:
	
	GameSettings.use_mouse = true
	_finish_test()

func _no_mouse_selected() -> void:
	
	GameSettings.use_mouse = false
	_finish_test()
	
func _finish_test() -> void:
	print("Используется мышь: ", GameSettings.use_mouse)
	get_tree().change_scene_to_file("res://levels/test_polygon/test_polygon.tscn")
