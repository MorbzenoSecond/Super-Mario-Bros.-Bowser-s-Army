extends CharacterBody2D

class_name Bomb

@export var horizontal_speed := -30
@export var gravity := 300.0
@onready var ray_cast_front = $Front
@onready var ray_cast_back = $Back
@onready var death = $die
@onready var player = $Player_cast
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var explosion_radio = $Explosion_radio as AnimatedSprite2D
@onready var explosion_effect = $Explosion as Area2D
var muerto : bool = false

var player_colide_uh = false
var incremental_value  = 0
var is_about_to_explote = false

var initial_position: Vector2
var attacking = false
var target_position = Vector2.ZERO
var attack_spped = 300

var turn_cooldown := 0.0
const TURN_DELAY := 0.2

func _ready() -> void:
	animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	$AnimatedSprite2D.play("walk")
	initial_position = global_position
	#inactive()


func _physics_process(delta: float) -> void:
	turn_cooldown -= delta

	if not is_on_floor():
		velocity.y += 1000 * delta
	else:
		velocity.y = 0

	if not attacking:
		velocity.x = horizontal_speed

		if ray_cast_back.is_colliding() and ray_cast_front.is_colliding() and turn_cooldown <=0 and not muerto:
			horizontal_speed = 0

		if ray_cast_front.is_colliding() and turn_cooldown <= 0:
			horizontal_speed *= -1
			animated_sprite_2d.flip_h = -horizontal_speed < 0
			player.scale.x = -sign(horizontal_speed)
			turn_cooldown = TURN_DELAY

		if ray_cast_back.is_colliding() and turn_cooldown <= 0: 
			horizontal_speed *= -1
			animated_sprite_2d.flip_h = -horizontal_speed < 0
			player.scale.x = -sign(horizontal_speed)
			turn_cooldown = TURN_DELAY
			
		if player.is_colliding():
			var collider = player.get_collider()
			if collider and collider.is_in_group("Player"):
				target_position = collider.global_position
				horizontal_speed = 0 # <- DETIENE EL CAMINAR
				animated_sprite_2d.play("detected")
				await get_tree().create_timer(1.0).timeout
				attacking = true
				player_colide_uh = true

	if attacking:
		animated_sprite_2d.speed_scale = 3.0
		animated_sprite_2d.play("walk")
		if player_colide_uh:
			var direction = (target_position - global_position).normalized()
			velocity.x = direction.x * attack_spped
		incremental_value = incremental_value + 0.015
		prepare()
		if velocity.x > -10 and velocity.x < 10:
			animated_sprite_2d.play("prepare")

	move_and_slide()

func pisoton():
	velocity.x = 0
	attacking = true
	muerto = true
	animated_sprite_2d.material.set_shader_parameter("flash_speed", incremental_value - 0.5)
	animated_sprite_2d.material.set_shader_parameter("flash_strength", incremental_value)
	if incremental_value > 5:
		explote()

func prepare():
	attacking = true
	muerto = true
	animated_sprite_2d.material.set_shader_parameter("flash_speed", incremental_value - 0.5)
	animated_sprite_2d.material.set_shader_parameter("flash_strength", incremental_value)
	if incremental_value > 5:
		explote()

func explote():
	explosion_effect.monitoring = true
	for body in explosion_effect.get_overlapping_bodies():
		if body and body.is_in_group("Enemies"):
			body.die_by_block()
		if body and body.is_in_group("Player"):
			body.handle_explosion_collision()
		
		for brick in get_tree().get_nodes_in_group("Brick_golpeable"):
			if global_position.distance_to(brick.global_position) < 150:
				brick.bump(Player.PlayerMode.FIRE, "up")

		if body and body.is_in_group("Bombs") and body != self:
			body.prepare()

	explosion_radio.visible = true
	explosion_radio.material.set_shader_parameter("flash_strength", 5)
	await get_tree().create_timer(0.1).timeout
	queue_free()


func active():
	$AnimatedSprite2D.visible = true
	super.set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D.set_deferred("monitoring", true)
	$Area2D.set_deferred("monitorable", true)

func inactive():
	$AnimatedSprite2D.visible = false
	super.set_physics_process(false)
	global_position = initial_position
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)
