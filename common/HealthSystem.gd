class_name HealthSystem
extends Node2D

signal damage_taken(amount: int, knockback_dir: Vector2, knockback_force: float)
signal health_changed(current_health: int, max_health: int)
signal died

@export var max_health: int = 100:
	set(value):
		max_health = value
		if health_comp:
			health_comp.max_health = value
			
@export var hurtbox: Hurtbox
@export var health_bar: ProgressBar
@export var hide_bar_when_full: bool = true

@onready var health_comp: HealthComponent = $HealthComponent

func _ready() -> void:
	health_comp.max_health = max_health
	health_comp.current_health = max_health
	
	health_comp.died.connect(died.emit)
	health_comp.health_changed.connect(health_changed.emit)
	
	hurtbox.hurt.connect(_on_hurtbox_hurt)
	
	_setup_health_bar()
	

func _on_hurtbox_hurt(damage: int, knockback_dir: Vector2, knockback_force: float) -> void:
	health_comp.take_damage(damage)
	damage_taken.emit(damage, knockback_dir, knockback_force)
	
	if health_bar:
		health_bar.value = health_comp.current_health
		health_bar.visible = true
	
func _setup_health_bar() -> void:
	if not health_bar:
		return
		
	health_bar.max_value = max_health
	health_bar.value = health_comp.current_health
	health_bar.visible = not hide_bar_when_full
