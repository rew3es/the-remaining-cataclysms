extends StaticBody2D
@export var character: CharacterBody2D
@export var enemy: CharacterBody2D
@onready var thershold: Node2D = get_node_or_null("effect_trigger_threshold") 

func _ready() -> void:
	
	if thershold == null:
		push_warning("у обьекта нет порога срабатывания эффекта. ")
		return
var overlapsed := false
func _process(delta: float) -> void:
	#для игрока
	if not overlapsed and character.global_position.y < thershold.global_position.y:
		z_index = character.z_index + 1
		overlapsed = true
	if overlapsed and character.global_position.y > thershold.global_position.y:
		z_index = character.z_index - 1
		overlapsed = false 
	
