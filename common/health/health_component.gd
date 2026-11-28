class_name HealthComponent
extends Node

signal health_changed(current_health: int, max_health: int)
signal died

@export var hurtbox: HurtboxComponent
@export var max_health: int = 100

var _current_health: int

func _ready() -> void:
	_current_health = max_health
	if hurtbox:
		hurtbox.hit_received.connect(_on_hit_received)

func _on_hit_received(attack: AttackData) -> void:
	take_damage(attack.damage)

func take_damage(amount: int) -> void:
	if amount <= 0 or _current_health <= 0:
		return
		
	_current_health = max(0, _current_health - amount)
	health_changed.emit(_current_health, max_health)
	
	if _current_health == 0:
		died.emit()
