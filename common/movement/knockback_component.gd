class_name KnockbackComponent
extends Node

@export var hurtbox: HurtboxComponent
@export var movement_component: MovementComponent
@export var knockback_resistance: float = 1.0 # 0 - immunitet

func _ready() -> void:
	if hurtbox:
		hurtbox.hit_received.connect(_on_hit_received)

func _on_hit_received(attack: AttackData) -> void:
	if not movement_component or attack.knockback_force <= 0.0:
		return
		
	var parent_node := get_parent() as Node2D
	if parent_node:
		var direction: Vector2 = (parent_node.global_position - attack.source_position).normalized()
		movement_component.apply_impulse(direction * attack.knockback_force * knockback_resistance)
