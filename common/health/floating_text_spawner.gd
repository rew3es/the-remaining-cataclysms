class_name FloatingTextSpawner
extends Node

@export var health_component: HealthComponent
@export var text_scene: PackedScene
@export var spawn_offset: Vector2 = Vector2(0, -50)

func _ready() -> void:
	if health_component:
		health_component.slot_damaged.connect(_on_slot_damaged)

func _on_slot_damaged(slot: HealthSlot, damage_taken: int) -> void:
	if not text_scene:
		return
		
	var instance: FloatingText = text_scene.instantiate() as FloatingText
	if not instance:
		return
		
	get_tree().current_scene.add_child(instance)
	
	var random_x: float = randf_range(-15.0, 15.0)
	var parent_pos: Vector2 = (get_parent() as Node2D).global_position
	instance.global_position = parent_pos + spawn_offset + Vector2(random_x, 0)
	
	var text_color: Color = Color.INDIAN_RED if slot.deadly else Color.GOLD
	instance.setup("-%d (%s)" % [damage_taken, slot.part_name], text_color)
