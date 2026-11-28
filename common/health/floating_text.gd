class_name FloatingText
extends Node2D

@onready var label: Label = $Label

func setup(text_value: String, color: Color = Color.WHITE) -> void:
	label.text = text_value
	modulate = color
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 40.0, 0.7).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.7).set_delay(0.2)
	tween.chain().tween_callback(queue_free)
