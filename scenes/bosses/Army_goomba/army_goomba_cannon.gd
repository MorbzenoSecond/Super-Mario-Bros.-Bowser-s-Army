extends Node2D

@export var bullet: PackedScene
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_shoot:= true
var spining = false
var heating = 0.0
@onready var mario = get_tree().get_nodes_in_group("Player")[0]
var dir
var max_turn_speed = 3.0  
@onready var timer := $Timer
var ticks = 60

const FIREBALL_SCENE = preload("res://scenes/items/proyectiles/piranna_fire_ball.tscn")
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#mario = get_tree().get_nodes_in_group("Player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.

	##$Sprite2D3.rotate(deg_to_rad(4))
var tween = Tween

func shoot():
	tween = get_tree().create_tween() 
	tween.tween_property($Sprite2D3.material, "shader_parameter/intensity", heating / 100, 0.1)
	if heating >= 100:
		activate_weak_point()
		return
	heating += 3

	var direction 
	var flip
	if $"..".scale.y > 0:
		if global_position.x > mario.global_position.x:
			direction = $Sprite2D3.rotation + PI 
			flip = false
		else:
			return
	elif  $"..".scale.y < 0:
		if global_position.x < mario.global_position.x:
			direction = -($Sprite2D3.rotation + PI)
			flip = true
		else:
			return
	else:
		return

	var mob = bullet.instantiate()
	get_parent().get_parent().get_parent().add_child(mob)
	mob.global_position = $Sprite2D3/Path2D/PathFollow2D.global_position


	mob.rotation = direction 
	mob.sprite.flip_v = flip
	mob.z_index = 1
	var velocity = Vector2(400, 0)
	mob.linear_velocity = velocity.rotated(direction)

func _physics_process(delta: float) -> void:
	$Label.text = str(heating) + "%"
	dir = mario.global_position - $Sprite2D3.global_position
	var target_angle = -dir.angle() + PI 
	target_angle = clamp_angle(target_angle)
	if !spining:
		if $"..".scale.y > 0:
			if global_position.x > mario.global_position.x:
				$Sprite2D3.rotation = lerp_angle($Sprite2D3.rotation, target_angle, max_turn_speed * delta) 
			else: 
				$Sprite2D3.rotation = lerp_angle($Sprite2D3.rotation, 0, max_turn_speed * delta) 
		elif  $"..".scale.y < 0:
			if global_position.x < mario.global_position.x:
				$Sprite2D3.rotation = lerp_angle($Sprite2D3.rotation, -target_angle, max_turn_speed * delta) 
			else: 
				$Sprite2D3.rotation = lerp_angle($Sprite2D3.rotation, deg_to_rad(180), max_turn_speed * delta) 
	else:
		$Sprite2D3.rotate(deg_to_rad(4))

func clamp_angle(angle: float) -> float:
	var wrapped = wrapf(angle, -PI, PI)
	return -wrapped

func angle_difference(a: float, b: float) -> float:
	return wrapf(a - b + PI, 0, TAU) - PI

func _on_timer_timeout() -> void:
	shoot()
	timer.start(4)
	ticks = 60

func turn():
	$Sprite2D4.visible = false
	$Sprite2D.visible = false
	$Sprite2D3.visible = false 
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")

func end_turn():
	if $"..".scale.y > 0:
		if global_position.x < mario.global_position.x:
			$Sprite2D3.rotation = 180
	elif  $"..".scale.y < 0:
		if global_position.x > mario.global_position.x:
			$Sprite2D3.rotation = 0

	$Sprite2D4.visible = true
	$Sprite2D.visible = true
	$Sprite2D3.visible = true 
	$AnimatedSprite2D.visible = false

func activate_weak_point():
	$ColorRect.visible = true
	$ColorRect/Area2D/CollisionShape2D.disabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		heating = 0
		#get_parent().get_parent().queue_free()
