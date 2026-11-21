extends Node2D
@onready var Hitbox_collision: Hitbox = $Hitbox
var can_attack: bool = true
func _ready() -> void:
	_disable(true)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fast_attack_key") and  can_attack:
		can_attack = false
		_disable(false)
		print("fast_attack")
		await get_tree().create_timer(0.5).timeout
		_disable(true)
		can_attack = true
func _disable(on_off: bool):
	if on_off:
		Hitbox_collision.monitorable = false
		Hitbox_collision.visible = false
	else: 
		Hitbox_collision.monitorable = true
		Hitbox_collision.visible = true
