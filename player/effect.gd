extends Area2D
@export var house: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		#print("Персонаж вошёл в область")
		house.z_index = 1


func _on_body_exited(body: Node2D):
	if body is CharacterBody2D:
		#print("Персонаж вышел из области")
		house.z_index = 0
