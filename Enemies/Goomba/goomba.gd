extends Enemy


func _ready() -> void:
	$AnimatedSprite2D.play("walk")
	initial_position = global_position
	$AnimationPlayer.play("RESET")

func _physics_process(delta: float) -> void:
	turn_cooldown -= delta
	velocity.x = horizontal_speed
	if not is_on_floor():
		velocity.y += gravity * delta

	# Detectar colisión frontal para girar
	if ray_cast_front.is_colliding():
		horizontal_speed *= -1
		ray_cast_front.scale.x = -sign(horizontal_speed)
		ray_cast_back.scale.x = -sign(horizontal_speed)

		animated_sprite_2d.flip_h = -horizontal_speed < 0  # o > 0 según tu sprite
		# Flip visual del raycast
		turn_cooldown = TURN_DELAY

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
 
func call_child_active():
	animated_sprite_2d.play("walk")

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	super.active()
