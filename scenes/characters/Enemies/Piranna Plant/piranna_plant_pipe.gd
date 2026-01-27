extends Area2D

class_name pirrana_plant

var NormalArray = [Color(0.63, 0.06, 0.06, 1), Color(0.77, 0.18, 0.17, 1), 
				Color(0.84, 0.13, 0.13, 1), Color(1, 0.31, 0.31, 1)]
var PoisonArray = [Color(0.26, 0.20, 0.45, 1), Color(0.44, 0.37, 0.62, 1), 
				Color(0.73, 0.58, 0.92, 1), Color(0.81, 0.74, 0.92, 1)]
var FireArray = [Color(0.10, 0.05, 0.03, 1), Color(0.19, 0.07, 0.05, 1), 
				Color(0.28, 0.12, 0.09, 1), Color(0.45, 0.27, 0.23, 1)]
enum PirannaType { Normal, Fire, Poison } 
var dir
var mario 
var max_turn_speed = 3.0  
var base_angle = 0.0
var ticks = 60
var is_inside = false
var is_in_area = true
var initial_position = Vector2(0,0)
var mario_locket = false
var can_shoot = false
const FIREBALL_SCENE = preload("res://scenes/items/proyectiles/piranna_fire_ball.tscn")
@export var piranna_type: PirannaType = PirannaType.Normal
@onready var head = $Cabeza
@onready var root = $Tallo
@onready var animation = $AnimationPlayer
@onready var timer := $Timer

func _ready() -> void:
	update_shader()
	animation.play("Plant movement")
	initial_position = global_position
	#animation.play("Plant movement")
	mario = get_tree().get_nodes_in_group("Player")[0]
	base_angle = head.rotation

func _physics_process(delta: float) -> void:
	pass
	#if !is_inside and is_in_area:
		#dir = mario.global_position - head.global_position
		#mario_locket = true
	#else:
		#dir = $Marker2D.global_position - head.global_position
		#mario_locket = false
	#var target_angle = -dir.angle() + PI / 2 
#
	#target_angle = clamp_angle(target_angle)
	#head.rotation = lerp_angle(head.rotation, target_angle, max_turn_speed * delta)

func clamp_angle(angle: float) -> float:
	var wrapped = wrapf(angle, -PI, PI)
	return -wrapped
	
	

func angle_difference(a: float, b: float) -> float:
	return wrapf(a - b + PI, 0, TAU) - PI

func shoot():
	var fireball = FIREBALL_SCENE.instantiate()
	
	get_parent().add_child(fireball)

	fireball.global_position = head.global_position
	
	var direction = -(mario.global_position - head.global_position)
	fireball.setup(direction, piranna_type)
	
func update_shader():
	var currentColor = [0]
	match piranna_type:
		PirannaType.Normal:
			currentColor = NormalArray
		PirannaType.Fire:
			currentColor = FireArray
		PirannaType.Poison:
			currentColor = PoisonArray
	head.material = head.material.duplicate()
	head.material.set_shader_parameter("NEWCOLOR1", currentColor[0])
	head.material.set_shader_parameter("NEWCOLOR2", currentColor[1])
	head.material.set_shader_parameter("NEWCOLOR3", currentColor[2])
	head.material.set_shader_parameter("NEWCOLOR4", currentColor[3])

func _on_inner_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_inside = true

func _on_inner_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_inside = false

func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_in_area = true

func _on_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_in_area = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.handle_piranna_collision(self)

func die():
	queue_free()

func _on_timer_timeout() -> void:
	if piranna_type == PirannaType.Fire:
		shoot()
	timer.start(3)
	ticks = 60
