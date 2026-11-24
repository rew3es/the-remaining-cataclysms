extends Node2D
class_name Sword
enum Attack_type{FAST, POWERFUL}
@onready var hitbox: Hitbox = $Hitbox
signal sword_attacked(attack_type: Attack_type)
 



func _input(event: InputEvent) -> void:
		if event.is_action_pressed("fast_attack_key") and $SwordComponent.can_attack and not event.is_echo():
			sword_attacked.emit(Attack_type.FAST)
			_attack_config(150, 15)
			$SwordComponent._attack_procces("fast")
			
		if event.is_action_pressed("powerful_attack_key") and $SwordComponent.can_attack and not event.is_echo():
			sword_attacked.emit(Attack_type.POWERFUL)
			_attack_config(400, 30)
			$SwordComponent._attack_procces("powerful")
			

func _attack_config(knockback_force: float, damage: int):
	hitbox.knockback_force = knockback_force
	hitbox.damage = damage
