class_name HealthSlot
extends Resource

@export var part_name: String = "Body"
@export var max_health: int = 100
@export var deadly: bool = true
@export_range(1, 100) var hit_weight: int = 50

var current_health: int = 0
