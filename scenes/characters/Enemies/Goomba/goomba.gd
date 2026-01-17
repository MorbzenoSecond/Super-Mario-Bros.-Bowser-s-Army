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
 

func die_by_block():
	muerto = true
	death.play()
	horizontal_speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	gravity = 0
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	rotation_tween_function()
	position_tween_function()

func position_tween_function():
	position_tween = get_tree().create_tween()
	position_tween.tween_property($AnimatedSprite2D, "position",  Vector2(25, -30), 0.3).set_ease(Tween.EASE_IN_OUT)
	position_tween.tween_property($AnimatedSprite2D, "position",  Vector2(50, -40), 0.3).set_ease(Tween.EASE_IN_OUT)
	position_tween.tween_property($AnimatedSprite2D, "position",  Vector2(75, -30), 0.3).set_ease(Tween.EASE_IN_OUT)
	position_tween.tween_property($AnimatedSprite2D, "position",  Vector2(100, -20), 0.3).set_ease(Tween.EASE_IN_OUT)
	position_tween.tween_property($AnimatedSprite2D, "position",  Vector2(300, 300), 2).set_ease(Tween.EASE_IN_OUT)
	position_tween.parallel().tween_property($AnimatedSprite2D, "scale",  Vector2(0,0), 0.8).set_ease(Tween.EASE_IN_OUT)
	position_tween.parallel().tween_property($AnimatedSprite2D, "modulate",  Color("ffffff00"), 1).set_ease(Tween.EASE_IN_OUT)

func rotation_tween_function():
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property($AnimatedSprite2D, "rotation",  deg_to_rad(1080), 3).set_ease(Tween.EASE_IN_OUT)

func call_child_active():
	animated_sprite_2d.play("walk")

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	super.active()
