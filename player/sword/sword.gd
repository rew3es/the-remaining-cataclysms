extends Node2D
class_name sword
@onready var Hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox
@export var character: AnimatedSprite2D
static var is_attack_now: bool = false
var can_attack: bool = true

 


func _ready() -> void:
	_disable(true)
	hitbox.damage = 15
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("fast_attack_key") and can_attack and not event.is_echo():
			_attack_config(150, 15)
			_attack_procces("fast")
		if event.is_action_pressed("powerful_attack_key") and can_attack and not event.is_echo():
			_attack_config(400, 30)
			_attack_procces("powerful")
			
func _attack_procces(type: String): #основной метод атаки, который вызывает второстепенные + таймер 
	_start_attack()
	_disable(false)
	if type == "fast":
		await _move_hitbox("fast")
	if type == "powerful":
		await _move_hitbox("powerful")
	_disable(true)
	if type == "fast": await get_tree().create_timer(0.2).timeout # чтобы хитбокс успел вернуться и отключится, перед тем как игрок снова начнет бить
	elif type == "powerful": await get_tree().create_timer(0.3).timeout
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
	
func _move_hitbox(type: String): # метод, который вызывает подметоды. отвечает за движения хитбокса меча. а именно колизии
	match _mouse_possition_detect(): # проверяя позицию мыши, мы вызываем один из подметодов атаки, в зависимости от положения курсора на экране
		"right": await _attack_right(type)
		"left": await _attack_left(type)
		"down": await _attack_back(type)
		"up": await _attack_forward(type) # PS: match это как switch case 

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
	

	
func _attack_forward(type: String):
	match type:
		"fast": await _general_attack("y", -15, -13.5, -150, 90, 10) # метод черезвычайно не абстрактный, и его пойму скорее всего только я 
		"powerful": await _general_attack("y", -25, -13.5, -250, 90, 20)
func _attack_back(type: String):
	match type:
		"fast": await _general_attack("y", 15, 13.5, 150, 90, 10)
		"powerful": await _general_attack("y", 25, -13.5, 250, 90, 20)
func _attack_right(type: String):
	match type:
		"fast": await _general_attack("x", 15, 0, 150, 90, 10)
		"powerful": await _general_attack("x", 25, 0, 250, 90, 20)
func _attack_left(type: String):
	match type:
		"fast": await _general_attack("x", -15, 0, -150, 90, 10)
		"powerful": await _general_attack("x", -25, 0, -250, 90, 20)
	
	
# ------------------------------------------------------------------------------------------------
# метод _general_attack() позволяет настроить движение хитбокса под свои нужды. которко отпишу его аргументы
#  на примере _general_attack("x", -15, 0, -160, 90)
# первый аргумент "x" - String-значение которое выбирает координату, тоесть движение влево вправо - это движение по оси х. 
# второй аргумент это то значение, на которое Hitbox_collision будет сдвигаться каждый кадр на протяжении 10 кадров. тоесть -15 это на 150 влево в суме 
# третий аргумент почти так-же само как и первый, но отвечает за вращение хитбокса на протяжении 10 кадров. указывать в градусах (FLOAT) а не радианах, так как используется global_rotation_degrees 
# четвертый аргумент отвечает за возвращения хитбокса в начальное положение.
# пятый аргумент это угол под которым после возвращения будет хитбокс, обычно это 90.
# шестой аргумент - количество кадров. обычно 10 
# ---------------------------------------------------------------------------------------------- 

func _general_attack(transform_component: String, transform_position: int, transform_position_degree: float, transform_position_return: int,  transform_rotation_degree_return: float, frame_value: int):
	var itt = 1
	var varalignment: float = 10.0 / frame_value
	while itt <= frame_value:
		if(transform_component == "x"): Hitbox_collision.global_position.x += transform_position * varalignment
		elif(transform_component == "y"): Hitbox_collision.global_position.y += transform_position * varalignment
		Hitbox_collision.global_rotation_degrees += transform_position_degree * varalignment
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

func _attack_config(knockback_force: float, damage: int):
	hitbox.knockback_force = knockback_force
	hitbox.damage = damage
	
