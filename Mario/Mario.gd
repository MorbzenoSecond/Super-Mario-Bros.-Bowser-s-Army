extends CharacterBody2D
class_name Player 
enum PlayerMode { SMALL, BIG, FIRE } 
var MAX_SPEED = 250.0
var RUN_MAX_SPEED = 500
var DUCK_MAX_SPEED = 35
const ACCELERATION = 600.0
const FRICTION = -500.0
const JUMP_FORCE = -1150.0
const JUMP_CUTOFF = -50.0
const GRAVITY = 900.0
var screen_size
const DRIFT_MIN_SPEED = 200.0
var respawn_position:Vector2
var is_dead = false
var is_talking = false


@export var Player_mode: PlayerMode = PlayerMode.SMALL
@export_group("stomping")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -400
@export_group("")
@onready var Fire := $Fire
@onready var collision:= $CollisionShape2D
@onready var shape = $CollisionShape2D.shape as RectangleShape2D
@onready var area = $Area2D
@onready var Area_collision = $Area2D/CollisionShape2D.shape as RectangleShape2D
@onready var Iframe_timer:= $Iframe
@onready var marker := $Marker2D
@export var dust: PackedScene
var Iframe_active = false
@onready var left_inner = $left_inner
@onready var left_outer = $left_outer
@onready var right_inner = $right_inner
@onready var right_outer = $right_outer
@onready var left = $left
@onready var right = $right
@onready var internal_ray_cast = $internal_ray_cast
@onready var down_right = $down_right
@onready var not_right = $not_down_right


func update_active_sprite():
	for sprite in[$Small, $Fire, $Big]:
		sprite.visible = false
	match Player_mode:
		PlayerMode.SMALL:
			_small_collision()
			$Small.visible = true
		PlayerMode.BIG:
			_big_collision()
			$Big.visible= true
		PlayerMode.FIRE:
			_big_collision()
			$Fire.visible = true

func get_current_sprite()->AnimatedSprite2D:
	match Player_mode:
		PlayerMode.SMALL:
			return $Small
		PlayerMode.BIG:
			return $Big
		PlayerMode.FIRE:
			return $Fire
	return $Small

func _ready() -> void:
	var instance = dust.instantiate()
	instance.global_position = $Marker2D.global_position
	if PlayerSpawnPoint.respawn_pending:
		global_position = PlayerSpawnPoint.last_checkpoint_position
		PlayerSpawnPoint.respawn_pending = false
	is_dead= false
	get_current_sprite().animation = "idle"
	$Area2D.set_collision_layer_value(1, true)
	$Area2D.set_collision_mask_value(3, true)
	set_physics_process(true)
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	respawn_position = global_position
	update_active_sprite()
	$AnimationPlayer.play("RESET")
	get_current_sprite().animation = "idle"

func _physics_process(delta: float) -> void:
	apply_floor_snap()
	move_and_slide()
	if not is_on_floor():
		velocity.y += (GRAVITY * 3 * delta) 
	
	if internal_ray_cast.is_colliding():
		collision.disabled = true
		global_position.y -= 25
	else:
		collision.disabled = false

	var collision_actual = get_last_slide_collision()
	if collision_actual != null:

		handle_movement_collision(collision_actual)

func handle_movement_collision(collision: KinematicCollision2D):
	if collision.get_collider() is Block:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) == 180:
			(collision.get_collider() as Block).bump(Player_mode)

func _on_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		handle_enemy_collision(enemy)
	elif enemy is Bullet:
		if area.name == "TopArea":
			handle_bullet_top_collision(enemy)
		else:
			handle_bullet_collision(enemy)
	elif enemy is Shroom:
		return
	elif enemy is Fire_flower:
		handle_fire_flower_collision(enemy)
	elif enemy is Bomb:
		handle_bob_omb_collision(enemy)


func handle_bob_omb_collision(enemy:Bomb):
	if enemy == null:
		return
	print("posición del enemigo: ", enemy.position.y)
	if global_position.y < enemy.global_position.y - 15:
		enemy.pisoton()
		on_enemy_stomped()
		print("accedio")
	else:
		if !Player_mode == PlayerMode.SMALL:
			Player_mode = PlayerMode.SMALL
			print(Player_mode)
			update_active_sprite()
		else:
			die()

func handle_explosion_collision():
	if Iframe_active:
		return
	if !Player_mode == PlayerMode.SMALL:
		Player_mode = PlayerMode.SMALL
		print(Player_mode)
		update_active_sprite()
		_i_frame_start()
	else:
		die()

func handle_bullet_top_collision(enemy: Bullet) -> void:
	if enemy == null:
		return
	enemy.top()

func handle_enemy_collision(enemy:Enemy):
	if enemy == null:
		return
		
	if global_position.y < enemy.global_position.y - 30:
		enemy.hit()
		on_enemy_stomped()
	else:
		if !Iframe_active:
			_i_frame_start()
			if !Player_mode == PlayerMode.SMALL:
				print("golpea a mario")
				Player_mode = PlayerMode.SMALL
				update_active_sprite()
			else:
				die()
		else: 
			return

func handle_bullet_collision(enemy:Bullet):
	if enemy == null:
		return
	if global_position.y < enemy.global_position.y - 30:
		enemy.die()
		on_enemy_stomped()
	else:
		if !Player_mode == PlayerMode.SMALL:
			Player_mode = PlayerMode.SMALL
			print(Player_mode)
			update_active_sprite()
		else:
			die()

func handle_fire_flower_collision(enemy:Fire_flower):
	Player_mode = PlayerMode.FIRE
	update_active_sprite()
	enemy.used()
	print("ahora eres fuego")

func on_enemy_stomped():
	if Input.is_key_pressed(KEY_SPACE):
		velocity.y = stomp_y_velocity - 800
	else:
		velocity.y = stomp_y_velocity

func die():     
	is_dead = true
	# Deferir cambios de colisión
	$Area2D.call_deferred("set_collision_layer_value", 1, false)
	$Area2D.call_deferred("set_collision_mask_value", 3, false)
	call_deferred("set_physics_process", false)
	call_deferred("set_collision_layer_value", 1, false)
	call_deferred("set_collision_mask_value", 1, false)
	get_current_sprite().play("death")  
	$Death.play()

	var death_tween = get_tree().create_tween()
	$AnimationPlayer.play("die")
	await get_tree().create_timer(3.0).timeout
	var spawn = get_parent()
	spawn.respawn_from_checkpoint()

var pipe_exit_animation

func enter_tube():
	print("tuberia")
	$Area2D.call_deferred("set_collision_layer_value", 1, false)
	$Area2D.call_deferred("set_collision_mask_value", 3, false)
	call_deferred("set_physics_process", false)
	call_deferred("set_collision_layer_value", 1, false)
	call_deferred("set_collision_mask_value", 1, false)
	z_index = -1000
	pipe_exit_animation = "pipe_down"
	$AnimationPlayer.play("pipe_down") 

func exit_tube():
	$Area2D.call_deferred("set_collision_layer_value", 1, true)
	$Area2D.call_deferred("set_collision_mask_value", 3, true)
	call_deferred("set_collision_layer_value", 1, true)
	call_deferred("set_collision_mask_value", 1, true)
	
	$AnimationPlayer.play_backwards(pipe_exit_animation) 
	await $AnimationPlayer.animation_finished
	z_index = 1000
	call_deferred("set_physics_process", true)

func _small_collision():
	shape.extents = Vector2(7, 8)
	Area_collision.extents = Vector2(7,8)
	$Area2D/CollisionShape2D.position = Vector2(0,1)
	$CollisionShape2D.position = Vector2(0, 1) 

func _big_collision():
	shape.extents = Vector2(6, 16)
	Area_collision.extents = Vector2(7,16)
	$Area2D/CollisionShape2D.position = Vector2(0,-7)
	$CollisionShape2D.position = Vector2(0, -7) 
	  # Más alto

func _i_frame_start():
	Iframe_active = true
	Iframe_timer.start()

func _on_iframe_timeout() -> void:
	Iframe_active = false
	Iframe_timer.stop()

func set_spawnpoint(pos:Vector2):
	respawn_position = pos
	
func respawn():
	global_position=respawn_position
	_ready()
