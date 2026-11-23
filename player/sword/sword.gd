extends Node2D
class_name sword
@onready var Hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@export var character: AnimatedSprite2D
static var is_attack_now: bool = false
var can_attack: bool = true
func _ready() -> void:
	_disable(true)
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("fast_attack_key") and can_attack and not event.is_echo():
			_attack_procces()
			
func _attack_procces(): #основной метод атаки, который вызывает второстепенные + таймер 
	_start_attack()
	_disable(false)
	await _move_hitbox()
	_disable(true)
	await get_tree().create_timer(0.2).timeout # чтобы хитбокс успел вернуться и отключится, перед тем как игрок снова начнет бить
	_stop_attack()

func _start_attack(): # метод начала атаки который включает состояние атаки, переключает анимации, запрещает атаковать повторно.
	is_attack_now = true
	character.stop()
	can_attack = false
	character.play("attack")
	
func _stop_attack(): # метод конца атаки, который включает возможность атаковать повторно, выключает анимацию атаки, убирает состояние атаки 
	can_attack = true
	character.stop()
	is_attack_now = false
	
func _move_hitbox(): # метод, который вызывает подметоды. отвечает за движения хитбокса меча. а именно колизии
	match _mouse_possition_detect(): # проверяя позицию мыши, мы вызываем один из подметодов атаки, в зависимости от положения курсора на экране
		"right": await _attack_right()
		"left": await _attack_left()
		"down": await _attack_back()
		"up": await _attack_forward() # PS: match это как switch case 

func _mouse_possition_detect():
	var mouse_possition = get_viewport().get_mouse_position() # вектор позиции мышки 
	var center = get_viewport_rect().size / 2 # векторп центра экрана
	var direction = mouse_possition - center # где мышь
	if abs(direction.x) > abs(direction.y): # если модуль координаты мышки по х больше модуля координаты мышки по y (просто смотрим, находится ли мышь ближе к боку экрана чем к низу или верху)
		if direction.x > 0:
			return "right"  # мышь справа
		else: return "left" # мышь справа
	else:
		if direction.y > 0: 
			return "down" # мышь снизу
		else: return "up" # мышь сверху
	

	
func _attack_forward():
	await _general_attack("y", -15, -13.5, -160, 90) # метод черезвычайно не абстрактный, и его пойму скорее всего только я 
func _attack_back():
	await _general_attack("y", 15, 13.5, 160, 90)
func _attack_right():
	await _general_attack("x", 15, 0, 150, 90)
func _attack_left():
	await _general_attack("x", -15, 0, -150, 90)
	
# ------------------------------------------------------------------------------------------------
# метод _general_attack() позволяет настроить движение хитбокса под свои нужды. которко отпишу его аргументы
#  на примере _general_attack("x", -15, 0, -160, 90)
# первый аргумент "x" - String-значение которое выбирает координату, тоесть движение влево вправо - это движение по оси х. 
# второй аргумент это то значение, на которое Hitbox_collision будет сдвигаться каждый кадр на протяжении 10 кадров. тоесть -15 это на 150 влево в суме 
# третий аргумент почти так-же само как и первый, но отвечает за вращение хитбокса на протяжении 10 кадров. указывать в градусах (FLOAT) а не радианах, так как используется global_rotation_degrees 
# четвертый аргумент отвечает за возвращения хитбокса в начальное положение.
# пятый аргумент это угол под которым после возвращения будет хитбокс, по умолчанию это 90.
# ---------------------------------------------------------------------------------------------- 

func _general_attack(transform_component: String, transform_position: int, transform_position_degree: float, transform_position_return: int,  transform_rotation_degree_return: float):
	var itt = 1
	while itt <= 10:
		if(transform_component == "x"): Hitbox_collision.global_position.x += transform_position
		elif(transform_component == "y"): Hitbox_collision.global_position.y += transform_position
		Hitbox_collision.global_rotation_degrees += transform_position_degree
		await get_tree().process_frame
		itt += 1
	await get_tree().create_timer(0.1).timeout
	if(transform_component == "x"): Hitbox_collision.global_position.x -= transform_position_return 
	elif(transform_component == "y"): Hitbox_collision.global_position.y -= transform_position_return
	Hitbox_collision.global_rotation_degrees = transform_rotation_degree_return


func _disable(on_off: bool): # отвечает за включение и выключение колизии хитбокса . передается булевое значнеие в аргумент. если true - то выключаем, если false - то включаем 
	if on_off:
		Hitbox_collision.set_deferred("disabled", on_off)
		Hitbox_collision.visible = not on_off
	else: 
		Hitbox_collision.set_deferred("disabled", on_off)
		Hitbox_collision.visible = not on_off
