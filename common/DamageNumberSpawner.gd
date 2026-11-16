class_name DamageNumberSpawner
extends Node2D

@export var health_system: HealthSystem

@export var text_color: Color = Color.WHITE

@export var font_size: int = 12

func _ready() -> void:
	if health_system:
		health_system.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(amount: int, _knockback_dir: Vector2, _knockback_force: float) -> void:
	spawn_number(amount)

func spawn_number(amount: int) -> void:
	var label := Label.new()
	label.text = str(amount)
	label.z_index = 100
	
	var settings := LabelSettings.new()
	settings.font_size = font_size
	settings.font_color = text_color
	settings.outline_size = 3
	settings.outline_color = Color.BLACK
	label.label_settings = settings
	
	get_tree().current_scene.add_child(label)
	
	var random_x: float = randf_range(-10.0, 10.0)
	label.global_position = global_position + Vector2(random_x, -10.0)
	
	var tween: Tween = label.create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(label, "global_position:y", label.global_position.y - 35.0, 0.6)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(label, "modulate:a", 0.0, 0.3).set_delay(0.3)
	
	tween.chain().tween_callback(label.queue_free)
