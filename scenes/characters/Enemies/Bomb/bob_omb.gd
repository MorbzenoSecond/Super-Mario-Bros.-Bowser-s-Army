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
@onready var sounds = $AudioStreamPlayer2D as AudioStreamPlayer2D
@onready var camera: Camera2D = get_tree().get_first_node_in_group("active_camera")
var muerto : bool = false

var incremental_value  = 0.0 
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
	velocity.y += gravity * delta
	move_and_slide()

var tween :Tween
func pisoton():
	$"State Machine".change_state("PrepareExplosionLegLess")
	gravity = 900.0

	var angle = randf_range(-PI / 4, -3 * PI / 4)
	var speed = randf_range(150.0, 200.0)
	velocity = Vector2.RIGHT.rotated(angle) * speed

	if tween != null and tween.is_running():
		tween.kill()

	prepare()


func prepare():
	incremental_value = 0.0

	tween = create_tween()

	tween.tween_property(self, "incremental_value", 5.1, 5.6)

	sounds.stream = load("res://scenes/characters/Enemies/Bomb/EnemyBombhei_BombWait.ogg")
	sounds.play()


func update_shader():
	animated_sprite_2d.material.set_shader_parameter("flash_speed", incremental_value - 0.5)
	animated_sprite_2d.material.set_shader_parameter("flash_strength", incremental_value)
	if incremental_value > 5:
		explote()

func explote():
	$Area2D/CollisionShape2D.disabled = true
	$Explosion/CollisionShape2D.disabled = false
	$AnimatedSprite2D.hide()
	for body in explosion_effect.get_overlapping_bodies():
		if body and body.is_in_group("Enemies"):
			body.die_by_block()
		if body and body.is_in_group("Player"):
			body.handle_explosion_collision()
		if body.is_in_group("Brick_golpeable"):
			body.bump(Player.PlayerMode.FIRE, "up")
			print("explosion_in_brick")

	explosion_radio.visible = true
	explosion_radio.material.set_shader_parameter("flash_strength", 5)
	$CPUParticles2D.emitting = true
	camera.trigger_shake(5)
	await get_tree().create_timer(0.5).timeout
	$Explosion/CollisionShape2D.disabled = true
	$CPUParticles2D.emitting = false
	await get_tree().create_timer(0.5).timeout
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


func _on_audio_stream_player_2d_finished() -> void:
	sounds.stream = load("res://scenes/characters/Enemies/Bomb/EnemyBombhei_Bomb.ogg")
	sounds.play()
