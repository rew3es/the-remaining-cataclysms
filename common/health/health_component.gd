class_name HealthComponent
extends Node

signal health_changed(current_total: int, max_total: int)
signal slot_damaged(slot: HealthSlot, damage_taken: int)
signal slot_destroyed(slot: HealthSlot)
signal died

@export var hurtbox: HurtboxComponent
@export var slots: Array[HealthSlot] = []

var _runtime_slots: Array[HealthSlot] = []
var _is_dead: bool = false

func _ready() -> void:
	if hurtbox:
		hurtbox.hit_received.connect(_on_hit_received)
		
	for slot_template in slots:
		if slot_template:
			var instance := slot_template.duplicate() as HealthSlot
			instance.current_health = instance.max_health
			_runtime_slots.append(instance)

func _on_hit_received(attack: AttackData) -> void:
	take_damage(attack.damage)

func take_damage(amount: int) -> void:
	if amount <= 0 or _is_dead or _runtime_slots.is_empty():
		return
		
	var alive_slots: Array[HealthSlot] = []
	for slot in _runtime_slots:
		if slot.current_health > 0:
			alive_slots.append(slot)
			
	if alive_slots.is_empty():
		return
		
	var target_slot: HealthSlot = _pick_weighted_slot(alive_slots)
	
	target_slot.current_health = max(0, target_slot.current_health - amount)
	slot_damaged.emit(target_slot, amount)
	health_changed.emit(get_total_current_health(), get_total_max_health())
	
	if target_slot.current_health == 0:
		slot_destroyed.emit(target_slot)
		if target_slot.deadly:
			_die()

func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	health_changed.emit(0, get_total_max_health())
	died.emit()
	
func _pick_weighted_slot(alive_slots: Array[HealthSlot]) -> HealthSlot:
	var total_weight: int = 0
	for slot in alive_slots:
		total_weight += slot.hit_weight
		
	var random_roll: int = randi_range(1, total_weight)
	var current_sum: int = 0
	
	for slot in alive_slots:
		current_sum += slot.hit_weight
		if random_roll <= current_sum:
			return slot
			
	return alive_slots.back()

func get_total_current_health() -> int:
	var total: int = 0
	for slot in _runtime_slots:
		if slot.deadly:
			total += slot.current_health
	return total

func get_total_max_health() -> int:
	var total: int = 0
	for slot in _runtime_slots:
		if slot.deadly:
			total += slot.max_health
	return total
