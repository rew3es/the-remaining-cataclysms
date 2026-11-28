class_name MovementComponent
extends Node

@export var body: CharacterBody2D
@export var max_speed: float = 300.0
@export var friction: float = 1200.0

var _move_direction: Vector2 = Vector2.ZERO
var _external_impulse: Vector2 = Vector2.ZERO

func set_movement_direction(direction: Vector2) -> void:
	_move_direction = direction.normalized()

func apply_impulse(impulse: Vector2) -> void:
	_external_impulse += impulse

func _physics_process(delta: float) -> void:
	if not body:
		return
		
	_external_impulse = _external_impulse.move_toward(Vector2.ZERO, friction * delta)
	body.velocity = (_move_direction * max_speed) + _external_impulse
	body.move_and_slide()
