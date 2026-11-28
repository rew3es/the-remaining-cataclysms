extends CharacterBody2D

@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		PlayerState.register_health_slots(health_component._runtime_slots)
		health_component.slot_damaged.connect(_on_slot_damaged)

func _on_slot_damaged(slot: HealthSlot, _damage: int) -> void:
	PlayerState.notify_health_updated(slot)
