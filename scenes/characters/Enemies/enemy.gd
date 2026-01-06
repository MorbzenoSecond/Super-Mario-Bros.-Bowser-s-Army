extends CharacterBody2D
class_name Enemy

@export var horizontal_speed := -30
@export var gravity := 600.0
@onready var ray_cast_front = $Front
@onready var ray_cast_back = $Back
@onready var death = $die
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var area_collision = $Area2D/CollisionShape2D
var initial_position: Vector2
var muerto : bool = false
var is_active : bool = true 
var initial_direction:=-1
var world:Node2D

var turn_cooldown := 0.0
const TURN_DELAY := 0.2

const MESSAGE_SCENE = preload("res://usefull gd/in_game_message.tscn")

func _ready() -> void:
	
	initial_position = global_position
	initial_direction = sign(horizontal_speed)
	#world.flag_reached.connect(all_die)
	$CollisionShape2D.disabled = false
	$Area2D.monitorable = true
	$Area2D.monitoring = true

func all_die():
	if is_active:
		hit()

func _physics_process(delta: float) -> void:
	move_and_slide()
	if muerto:
		return

func _turn():
	horizontal_speed *= -1
	ray_cast_front.scale.x = -sign(horizontal_speed)
	ray_cast_back.scale.x = -sign(horizontal_speed)
	turn_cooldown = TURN_DELAY

func hit():
	var message = MESSAGE_SCENE.instantiate()
	var level = get_parent()
	level.add_child(message)
	message.global_position = global_position + Vector2(0, -60)
	message.setup(null, 200)

	call_child_ready()

func call_child_ready():
	pass

func die_by_block():
	muerto = true
	death.play()
	horizontal_speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	gravity = 0
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	animated_sprite_2d.play("death_by_brick")
	$AnimationPlayer.play("die_by_block")

func active():
	is_active = true
	rotation_degrees = 0
	var mario = get_node("/root/GameWorld/Mario")
	$AnimationPlayer.play("RESET")
	if position.distance_to(mario.position)<400:
		return
	call_child_active()
	gravity = 300
	muerto = false
	$AnimatedSprite2D.visible = true
	super.set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D.set_deferred("monitoring", true)
	$Area2D.set_deferred("monitorable", true)
	horizontal_speed = -60
	animated_sprite_2d.flip_h = -horizontal_speed < 0
	ray_cast_front.scale.x = -sign(horizontal_speed)
	ray_cast_back.scale.x = -sign(horizontal_speed)

func call_child_active():
	pass

func inactive():
	is_active = false
	$AnimatedSprite2D.visible = false
	super.set_physics_process(false)
	global_position = initial_position
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)
