extends Node
class_name PlayerAnimationSwitcher

@onready var character: AnimatedSprite2D = get_tree().current_scene.get_node("sort_object/player/AnimatedSprite2D")
@onready var sword_logic: SwordLogic = get_tree().current_scene.get_node("sort_object/player/Sword/SwordComponent")

func _ready() -> void:
	sword_logic.character_stop_animation.connect(_stop_player_anim)
	sword_logic.character_switch_animation_to_attack.connect(_swicth_player_anim_t_a)

func _stop_player_anim():
	character.stop()
func _swicth_player_anim_t_a():
	character.stop()
	character.play("attack")

func _input(_event: InputEvent) -> void:
	if (
		Input.is_action_pressed("move_player_forward") or
		Input.is_action_pressed("move_player_back") or
		Input.is_action_pressed("move_player_left") or
		Input.is_action_pressed("move_player_right")
	):
		if !sword_logic.is_attack_now:
			character.play("walk")
	else:
		if !sword_logic.is_attack_now:
			character.play("idle")
