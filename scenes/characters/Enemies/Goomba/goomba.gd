extends Enemy

func _ready() -> void:
	$AnimatedSprite2D.play("walk")
	initial_position = global_position
	$AnimationPlayer.play("RESET")

var position_tween : Tween
var rotation_tween : Tween

func _physics_process(delta: float) -> void:
	turn_cooldown -= delta
	velocity.x = horizontal_speed
	if not is_on_floor():
		velocity.y += gravity * delta

	# Detectar colisión frontal para girar
	if ray_cast_front.is_colliding():
		super._turn()
		animated_sprite_2d.flip_h = -horizontal_speed < 0  # o > 0 según tu sprite

	if ray_cast_back.is_colliding() and ray_cast_front.is_colliding() and not muerto:
		animated_sprite_2d.play("Trap")
		horizontal_speed = 0

	var _previous_position = position
	move_and_slide()

func call_child_ready():
	muerto = true
	death.play()
	horizontal_speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	animated_sprite_2d.play("death")
	gravity = 0
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	await get_tree().create_timer(0.7).timeout
	$AnimatedSprite2D.visible = false
	super.inactive()
 

func big_hit(direction):
	muerto = true
	death.play()
	horizontal_speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	gravity = 0
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	$AnimatedSprite2D.play("death_by_big_hit")
	rotation_tween_function(direction)
	position_tween_function(direction)

func position_tween_function(direction):

	position_tween = get_tree().create_tween()
	#position_tween.set_trans(Tween.TRANS_SINE)
	position_tween.set_ease(Tween.EASE_OUT)

	position_tween.tween_property($AnimatedSprite2D, "position", Vector2(12 * direction, -18), 0.2)
	position_tween.tween_property($AnimatedSprite2D, "position", Vector2(28 * direction, -32), 0.22)
	position_tween.tween_property($AnimatedSprite2D, "position", Vector2(45 * direction, -22), 0.2)
	position_tween.tween_property($AnimatedSprite2D, "position", Vector2(60 * direction, -10), 0.18)

	await position_tween.finished
	super.point_score(200)
	$AnimatedSprite2D.play("invicible")
	$AnimatedSprite2D/puff_effect.restart()

func rotation_tween_function(direction):
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property($AnimatedSprite2D, "rotation",  deg_to_rad(480 * direction) , 0.8)

func call_child_active():
	animated_sprite_2d.play("walk")

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	super.active()
