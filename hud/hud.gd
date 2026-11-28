extends CanvasLayer

@export var health_bar: ProgressBar

func _ready() -> void:
	_on_health_changed(PlayerState.current_health, PlayerState.max_health)
	PlayerState.health_changed.connect(_on_health_changed)

func _on_health_changed(current: int, maximum: int) -> void:
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current
