class_name SlotUI
extends HBoxContainer

@onready var name_label: Label = $PartNameLabel
@onready var progress_bar: ProgressBar = $SlotProgressBar

var _target_slot: HealthSlot

func setup(slot: HealthSlot) -> void:
	_target_slot = slot
	name_label.text = slot.part_name
	progress_bar.max_value = slot.max_health
	progress_bar.value = slot.current_health
	_update_color()

func update_display() -> void:
	if not _target_slot:
		return
	progress_bar.value = _target_slot.current_health
	_update_color()

func _update_color() -> void:
	var ratio: float = float(_target_slot.current_health) / float(max(1, _target_slot.max_health))
	if ratio > 0.5:
		progress_bar.modulate = Color.LIME_GREEN
	elif ratio > 0.0:
		progress_bar.modulate = Color.GOLD
	else:
		progress_bar.modulate = Color.DARK_RED
