extends Camera2D

@onready var environment: Node = get_tree().current_scene.get_node("sort_object")
@onready var player: Node = environment.get_node("player")

var target_angle: int = 0  # копится без нормализации

func _ready() -> void:
	rotation_smoothing_enabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("clockwise_camera_rotation"):
		_rotate_by(90)
	elif event.is_action_pressed("counter_clockwise_camera_rotation"):
		_rotate_by(-90)

func _rotate_by(step: int) -> void:
	target_angle += step
	rotation_degrees = target_angle
	_control_adaptation(posmod(target_angle, 360))
	_environment_adaptation(target_angle)

func _control_adaptation(angle: int) -> void:
	player_move.set_default_controls()
	match angle:
		90:
			player_move.swap_vertical_and_horizontal_controls()
			player_move.swap_horizontal_controls()
		180:
			player_move.swap_vertical_controls()
			player_move.swap_horizontal_controls()
		270:
			player_move.swap_vertical_and_horizontal_controls()
			player_move.swap_vertical_controls()

func _environment_adaptation(angle: float) -> void:
	for obj in environment.get_children():
		for part in obj.get_children():
			if obj == player and (part == self or part.name == "CONFIG"):
				continue
			if part is Node2D:
				_rotate_part(part, angle)

func _rotate_part(part: Node2D, angle_deg: float) -> void:
	# запоминаем исходное смещение и вращаем его вокруг центра родителя
	if not part.has_meta("base_pos"):
		part.set_meta("base_pos", part.position)
	part.position = (part.get_meta("base_pos") as Vector2).rotated(deg_to_rad(angle_deg))
	part.rotation_degrees = angle_deg
