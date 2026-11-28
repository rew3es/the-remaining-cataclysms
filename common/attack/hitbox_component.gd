class_name HitboxComponent
extends Area2D

@export var attack_data: AttackData

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent and attack_data:
		var attack_instance := attack_data.duplicate() as AttackData
		attack_instance.source_position = global_position
		area.receive_hit(attack_instance)
