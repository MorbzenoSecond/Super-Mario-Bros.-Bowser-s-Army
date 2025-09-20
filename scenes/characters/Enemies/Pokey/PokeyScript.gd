extends CharacterBody2D
class_name PokeyBodyPart

@onready var floor = $Floor
@onready var ray_cast_front = $Front
@onready var ray_cast_back = $Back
@onready var ray_cast_down = $Down
var gravity = 300
@export var horizontal_speed := -30

var turn_cooldown := 0.0
const TURN_DELAY := 0.2
var is_on_tower = false

func _turn():
	horizontal_speed *= -1
	ray_cast_front.scale.x = -sign(horizontal_speed)
	ray_cast_back.scale.x = -sign(horizontal_speed)
	turn_cooldown = TURN_DELAY

func _physics_process(delta: float) -> void:
	# --- 1. Calcular gravedad ---
	if is_on_floor() and is_on_tower:
		velocity.y = 0
	else:
		velocity.y += gravity * delta

	# --- 2. Control de torre ---
	if is_on_tower:
		velocity.x = 0
	else:
		velocity.x = horizontal_speed

	# --- 3. Detectar colisiones frontales ---
	if ray_cast_front.is_colliding() and !is_on_tower:
		_turn()

	# --- 4. Detectar falta de suelo frente a él ---
	if not floor.is_colliding() and !is_on_tower:
		floor.position.x = -floor.position.x
		_turn()

	# --- 5. Mover al personaje ---
	move_and_slide()
	if ray_cast_down.is_colliding():
		if ray_cast_down.get_collider() is PokeyBodyPart:
			is_on_tower = true
		else:
			is_on_tower = false
	else:
		is_on_tower = false
