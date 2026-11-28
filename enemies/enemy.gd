extends CharacterBody2D

@export var health_component: HealthComponent
@export var health_bar: ProgressBar

func _ready() -> void:
	if health_component:
		if health_bar:
			health_bar.max_value = health_component.max_health
			health_bar.value = health_component.max_health
			health_bar.visible = false
			health_component.health_changed.connect(_on_health_changed)
		
		health_component.died.connect(_on_died)

func _on_health_changed(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health and current_health > 0

func _on_died() -> void:
	queue_free()
