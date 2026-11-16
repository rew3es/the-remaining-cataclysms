extends CharacterBody2D

@onready var health_system: HealthSystem = $HealthSystem
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	health_system.damage_taken.connect(_on_damage_taken)
	health_system.died.connect(_on_died)
	
	sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 600 * delta)
	move_and_slide()
	
func _on_damage_taken(_amount: int, knockback_dir: Vector2, knockback_force: float) -> void:
	velocity = knockback_dir * knockback_force
	
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func _on_died() -> void:
	queue_free()
