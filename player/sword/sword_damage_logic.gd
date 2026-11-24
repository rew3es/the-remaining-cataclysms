extends Node
@onready var sword = get_parent()

func _ready() -> void:
	sword.sword_attacked.connect(_attack_registrated)

func _attack_registrated(attack_type):
	match attack_type:
		Sword.Attack_type.FAST: print("FAST")
		Sword.Attack_type.POWERFUL: print("POWERFUL")
