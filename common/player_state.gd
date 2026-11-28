extends Node

signal health_changed(current_health: int, max_health: int)
signal slot_updated(slot: HealthSlot)
signal player_died

var current_health: int = 100
var max_health: int = 100
var health_slots: Array[HealthSlot] = []

func register_health_slots(slots: Array[HealthSlot]) -> void:
	health_slots = slots
	_recalculate_health()

func notify_health_updated(damaged_slot: HealthSlot = null) -> void:
	_recalculate_health()
	if damaged_slot:
		slot_updated.emit(damaged_slot)
	if current_health <= 0:
		player_died.emit()

func _recalculate_health() -> void:
	var cur: int = 0
	var maximum: int = 0
	for slot in health_slots:
		if slot.deadly:
			cur += slot.current_health
			maximum += slot.max_health
	
	current_health = cur
	max_health = max(1, maximum)
	health_changed.emit(current_health, max_health)
