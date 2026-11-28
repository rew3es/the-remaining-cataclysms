class_name HUD
extends CanvasLayer

@export var health_bar: ProgressBar
@export var slots_container: VBoxContainer
@export var slot_ui_scene: PackedScene

var _slot_widgets: Dictionary = {}

func _ready() -> void:
	_on_health_changed(PlayerState.current_health, PlayerState.max_health)
	PlayerState.health_changed.connect(_on_health_changed)
	
	if not PlayerState.health_slots.is_empty():
		_build_slots_ui(PlayerState.health_slots)
	PlayerState.slots_registered.connect(_build_slots_ui)
	PlayerState.slot_updated.connect(_on_slot_updated)

func _build_slots_ui(slots: Array[HealthSlot]) -> void:
	if not slots_container or not slot_ui_scene:
		return
		
	for child in slots_container.get_children():
		child.queue_free()
	_slot_widgets.clear()
	
	for slot in slots:
		var widget: SlotUI = slot_ui_scene.instantiate() as SlotUI
		slots_container.add_child(widget)
		widget.setup(slot)
		_slot_widgets[slot] = widget

func _on_slot_updated(slot: HealthSlot) -> void:
	if _slot_widgets.has(slot):
		var widget: SlotUI = _slot_widgets[slot]
		widget.update_display()

func _on_health_changed(current: int, maximum: int) -> void:
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current
