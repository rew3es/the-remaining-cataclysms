extends Area2D

@export var speed = 300  #скорость игрока - 300 едениц
var screen_size

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect() #получаем вектор (x, y) видимой области экрана
	


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # (0, 0) вектор передвижения игрока
	velocity = Input.get_vector(
		"move_player_left", "move_player_right",
		"move_player_forward", "move_player_back"
	) # Получает входной вектор, указывая четыре действия для положительных и отрицательных осей X и Y.
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size.size)
