class_name ChaseAIComponent
extends Node

@export var movement_component: MovementComponent
@export var separation_area: Area2D
@export var nav_agent: NavigationAgent2D

@export_group("Настройки агрессии")
@export var aggro_radius: float = 350.0
@export var stop_distance: float = 45.0
@export var speed_multiplier: float = 1.0

@export_group("Настройки нетолпления и навигации")
@export var separation_weight: float = 1.5
# Как часто пересчитывать маршрут (в секундах) для оптимизации
@export var path_update_interval: float = 0.2

var _target: Node2D = null
var _owner_body: Node2D
var _path_timer: float = 0.0

func _ready() -> void:
	_owner_body = get_parent() as Node2D
	_target = get_tree().get_first_node_in_group("player") as Node2D
	
	# Случайная задержка на старте, чтобы толпа врагов не считала пути в один и тот же кадр
	_path_timer = randf_range(0.0, path_update_interval)
	
	if nav_agent:
		# Настраиваем дистанцию остановки прямо в агенте навигации
		nav_agent.target_desired_distance = stop_distance

func _physics_process(delta: float) -> void:
	if not movement_component or not _owner_body:
		return
		
	if not is_instance_valid(_target):
		_target = get_tree().get_first_node_in_group("player") as Node2D
		movement_component.set_movement_direction(Vector2.ZERO)
		return

	var distance_to_target: float = _owner_body.global_position.distance_to(_target.global_position)
	
	# 1. Проверяем радиус агрессии
	if distance_to_target > aggro_radius:
		movement_component.set_movement_direction(Vector2.ZERO)
		return

	# 2. Обновляем цель для NavigationAgent2D по таймеру
	_path_timer -= delta
	if _path_timer <= 0.0:
		_path_timer = path_update_interval
		if nav_agent:
			nav_agent.target_position = _target.global_position

	# 3. Определяем направление к следующей точке маршрута (в обход стен)
	var seek_vector: Vector2 = Vector2.ZERO
	if distance_to_target > stop_distance:
		if nav_agent and not nav_agent.is_navigation_finished():
			var next_path_pos: Vector2 = nav_agent.get_next_path_position()
			seek_vector = (_owner_body.global_position.direction_to(next_path_pos))
		else:
			# Запасной вариант, если навигация не настроена на уровне
			seek_vector = (_owner_body.global_position.direction_to(_target.global_position))

	# 4. Добавляем расталкивание от других врагов
	var separation_vector: Vector2 = _calculate_separation()
	var final_direction: Vector2 = (seek_vector + separation_vector * separation_weight).normalized()
	
	movement_component.set_movement_direction(final_direction * speed_multiplier)

func _calculate_separation() -> Vector2:
	if not separation_area:
		return Vector2.ZERO
		
	var push_vector: Vector2 = Vector2.ZERO
	var neighbors: Array[Area2D] = separation_area.get_overlapping_areas()
	
	for neighbor in neighbors:
		if neighbor == separation_area:
			continue
			
		var diff: Vector2 = _owner_body.global_position - neighbor.global_position
		var dist: float = diff.length()
		if dist > 0.0:
			push_vector += diff.normalized() / dist * 20.0
			
	return push_vector
