extends CharacterBody2D
class_name Player 
enum PlayerMode { SMALL, BIG, FIRE } 
var MAX_SPEED = 250.0
var RUN_MAX_SPEED = 500
var DUCK_MAX_SPEED = 35
const ACCELERATION = 600.0
const JUMP_ACCELERATION = 800.0
const FRICTION = -500.0
const JUMP_FORCE = -1150.0
const JUMP_CUTOFF = -50.0
var GRAVITY = 900.0
var screen_size
const DRIFT_MIN_SPEED = 200.0
var respawn_position:Vector2
var is_dead = false
var is_talking = false
var direction = 0
var star = false
var in_fence = false
var using_fence = false
var snap = 32
var sliding = false
var falling = false
var in_yoshi = false
@onready var animation_player = $AnimationPlayer
@export var afterimage_scene = preload("res://assets/visual effects/after_image.tscn")
const FIREBALL_SCENE = preload("res://scenes/items/proyectiles/fire ball.tscn")
const yoshi = preload("res://scenes/characters/yoshi.tscn")
const MESSAGE_SCENE = preload("res://usefull gd/in_game_message.tscn")

var afterimage_timer := 0.0
var afterimage_interval := 0.05  # Cada cuánto deja una silueta
@export_group("Yoshi data")
@export var yoshi_MAX_SPEED = 300.0
@export var yoshi_RUN_MAX_SPEED = 600
@export var yoshi_ACCELERATION = 600.0
@export var yoshi_JUMP_ACCELERATION = 800.0
@export var yoshi_FRICTION = -500.0
@export var yoshi_JUMP_FORCE = -1350.0
@export var yoshi_JUMP_CUTOFF = -50.0
@export_group("")

@export var Player_mode: PlayerMode = PlayerMode.SMALL
@export_group("stomping")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -400
@export_group("")
@onready var Fire := $Fire
@onready var collision:= $CollisionShape2D
#@onready var shape = $CollisionShape2D.shape 
@onready var area = $Area2D
@onready var Area_collision = $Area2D/CollisionShape2D.shape as RectangleShape2D
@onready var Iframe_timer:= $Iframe
@onready var marker := $Marker2D
var Iframe_active = false
@onready var behind_inner = $left_inner
@onready var behind_outer = $left_outer
@onready var front_inner = $right_inner
@onready var front_outer = $right_outer
@onready var behind = $left
@onready var front = $right
@onready var internal_ray_cast = $internal_ray_cast
@onready var down = $down
@onready var fireball_shoot = $fireball_shoot
@onready var starTime = $StarTime
@export var skin : String = "res://Mario/Mario_cappy_skin.png" 
var actual_animation : String
var wall_jump_direction : int

func _on_change_skin(new_skin):
	var sheet = load(new_skin)
	var frames = SpriteFrames.new()
	var animationsArray = ["idle", "walk", "duck", "duck_enter", "duck_jump",
		"falling", "friction", "in fence", "jump", "left_right_fence",
		"mario_in_wall", "pound", "pound_fall", "riding_yoshi_idle",
		"run", "run_jump", "stare", "talking", "up_down-fence", "walking_duck"]
	var animationsFramesArray = [2,10,5,5,5,7,5,5,7,5,5,10,5,5,10,5,3,2,5,5]
	var animationsLoopArray = [true, true, false, true, false, false, false, true, 
	false, true, true, false, true, true, true, true, true, true, true, true]

	var animationsSectionArray = [Vector2(0,1), Vector2(6,9), Vector2(26,26), Vector2(25,25),
		Vector2(31,32), Vector2(17,18), Vector2(22,23), Vector2(37,37),
		Vector2(14,16), Vector2(41,43), Vector2(36,36), Vector2(33,34),
		Vector2(35,35), Vector2(45,45), Vector2(10,13), Vector2(19,19),
		Vector2(2,5), Vector2(20,21), Vector2(37,40), Vector2(27,30)]

	for i in range(animationsArray.size()):
		var anim_name = animationsArray[i]
		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, animationsFramesArray[i])
		frames.set_animation_loop(anim_name, animationsLoopArray[i])

		for e in range(animationsSectionArray[i].x, animationsSectionArray[i].y + 1):
			var frame = AtlasTexture.new()
			frame.atlas = sheet
			frame.region = Rect2(e * 42, 0, 42, 50)
			frames.add_frame(anim_name, frame)

	$Big.sprite_frames = frames
	update_active_sprite()

func update_active_sprite():
	get_current_sprite().play(actual_animation)
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
	_on_change_skin(skin)
	if PlayerSpawnPoint.respawn_pending:
		global_position = PlayerSpawnPoint.last_checkpoint_position
		PlayerSpawnPoint.respawn_pending = false
	is_dead= false
	set_physics_process(true)
	respawn_position = global_position

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		front.target_position.x = -10
		behind.target_position.x = 10
	if direction > 0:
		front.target_position.x = 10
		behind.target_position.x = -10
	floor_snap_length = snap
	move_and_slide()
	if not is_on_floor():
		velocity.y += (GRAVITY * 3 * delta) 
	if get_current_sprite().flip_h == false:
		fireball_shoot.position.x = 12
		direction = -1
	else:
		fireball_shoot.position.x = -12
		direction = 1

	if internal_ray_cast.is_colliding():
		collision.disabled = true
		global_position.y -= 25
	else:
		collision.disabled = false
	
	if Input.is_action_just_pressed("Shoot") and Player_mode == PlayerMode.FIRE:
		shoot()
	var collision_actual = get_last_slide_collision()
	if collision_actual != null:
		handle_movement_collision(collision_actual)
	in_fence = get_tile_fence_state()

func _process(delta):
	#if Input.is_action_pressed("enter"):
		#toggle()
	
	afterimage_timer += delta
	if afterimage_timer >= afterimage_interval and star:
		afterimage_timer = 0.0
		spawn_afterimage()

func get_tile_fence_state() -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("TileMapLayer")

	if not tilemap: 
		return false

	var cell = tilemap.local_to_map(position)
	cell.x = cell.x / 3
	cell.y = cell.y / 3
	var data: TileData = tilemap.get_cell_tile_data(cell)
	if data: 
		var state: bool = data.get_custom_data("is_in_fence")
		return state
	
	return false

func spawn_afterimage():
	var img = afterimage_scene.instantiate()
	img.setup(
		get_current_sprite(),  # AnimatedSprite2D del personaje
		global_position,
		Color(1, 0, 1, 0.4)  # Color violeta translúcido
	)
	get_parent().add_child(img)


func shoot():
	var fireball = FIREBALL_SCENE.instantiate()

	var level = get_parent().get_node("Levels").get_child(0)
	level.add_child(fireball)

	fireball.global_position = fireball_shoot.global_position
	
	fireball.setup(-sign(fireball_shoot.position.x), velocity.x)

func handle_movement_collision(collision: KinematicCollision2D):
	if collision.get_collider() is Block:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) == 180:
			(collision.get_collider() as Block).bump(Player_mode, "up")

func _on_area_2d_area_entered(area: Area2D) -> void:
	var father = area.get_parent()
	if father is Enemy:
		handle_enemy_collision(father)
	elif father is Bullet:
		if area.name == "TopArea":
			handle_bullet_top_collision(father)
		else:
			handle_bullet_collision(father)
	elif father is PowerUps:
		handle_power_ups_collision(father)
	elif father is Bomb:
		handle_bob_omb_collision(father)
	elif father.is_in_group("Enemies"):
		handle_dry_collision(father)

func handle_dry_collision(enemy):
	if enemy == null:
		return
	if star:
		enemy.die_by_block()
		return
	if sliding:
		enemy.die_by_block()
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

func handle_bob_omb_collision(enemy:Bomb):
	if enemy == null:
		return

	if global_position.y < enemy.global_position.y - 15:
		enemy.pisoton()
		on_enemy_stomped()

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
	if star:
		enemy.die_by_block()
		return
	if sliding:
		enemy.die_by_block()
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

func handle_piranna_collision(enemy):
	if enemy == null:
		return
	if star:
		enemy.die()
		return
	else:
		if !Iframe_active:
			_i_frame_start()
			if !Player_mode == PlayerMode.SMALL:
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
		if !Iframe_active:
			_i_frame_start()
			if !Player_mode == PlayerMode.SMALL:
				Player_mode = PlayerMode.SMALL
				update_active_sprite()
			else:
				die()
		else: 
			return

func handle_proyectil_collision(damage_type):
	if damage_type == null:
		return
	if star:
		return
	else:
		if !Iframe_active:
			_i_frame_start()
			if !Player_mode == PlayerMode.SMALL:
				Player_mode = PlayerMode.SMALL
				update_active_sprite()
			else:
				die()
		else: 
			return

func handle_power_ups_collision(power_up):
	if power_up is Shroom:
		send_message()
		Player_mode = PlayerMode.BIG
		update_active_sprite()
		if star:
			rainbow()
	elif power_up is Fire_flower:
		Player_mode = PlayerMode.FIRE
		update_active_sprite()
	elif power_up is Super_star:
		star = true
		rainbow()
		starTime.start()
		var music = get_parent().mario_super_star()

func on_enemy_stomped():
	if using_fence:
		return
		
	if Input.is_key_pressed(KEY_SPACE):
		GRAVITY = 900.0
		velocity.y = stomp_y_velocity - 800
	else:
		velocity.y = stomp_y_velocity

func die():     
	get_tree().paused = true
	var game = owner
	game.mario_die()
	is_dead = true
	# Deferir cambios de colisión
	call_deferred("set_physics_process", false)
	$Death.play()
	var death_tween = get_tree().create_tween()
	$AnimationPlayer.play("die")
	await get_tree().create_timer(3.0).timeout
	var spawn = get_parent()
	Player_mode = PlayerMode.SMALL
	spawn.respawn_from_checkpoint()

var pipe_exit_animation

func enter_tube():
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
	
	$AnimationPlayer.play(pipe_exit_animation) 
	await $AnimationPlayer.animation_finished
	z_index = 1000
	call_deferred("set_physics_process", true)

func _small_collision():
	animation_player.play("SMALL")

func _big_collision():
	animation_player.play("RESET")

func _i_frame_start():
	Iframe_active = true
	Iframe_timer.start()

func _on_iframe_timeout() -> void:
	Iframe_active = false
	Iframe_timer.stop()

func set_spawnpoint(pos:Vector2):
	respawn_position = pos
	
func respawn():
	get_tree().paused = false
	global_position=respawn_position
	_ready()

func _on_star_time_timeout() -> void:
	star = false
	desactivate_rainbow()
	var music = get_parent().mario_super_star_off()

func rainbow():
	var mat := get_current_sprite().material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("rainbow_enabled", true)

func desactivate_rainbow():
	var mat := get_current_sprite().material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("rainbow_enabled", false)

func toggle():
	get_tree().paused = !get_tree().paused

func send_message():
	var message = MESSAGE_SCENE.instantiate()
	var level = get_parent()
	level.add_child(message)
	message.global_position = global_position + Vector2(0, -12)
	if Player_mode == PlayerMode.SMALL:
		message.setup(load("res://assets/sprites/particles_sprites/Mushroom_plus.png"), null)
	else:
		message.setup(null, 1000)
