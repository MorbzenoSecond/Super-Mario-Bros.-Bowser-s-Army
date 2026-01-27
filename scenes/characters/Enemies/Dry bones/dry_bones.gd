extends Enemy

@onready var sound = $die

var original_positions = {}
var body_parts = {}

func _ready() -> void:
	$AnimationPlayer.play("walking")
	super._ready()

	body_parts = $BodyParts.get_children()

	for part in $BodyParts.get_children():
		part.rearmed()
		original_positions[part] = part.position

func all_die():
	hit()

func _physics_process(delta: float) -> void:
	if muerto:
		return
	turn_cooldown -= delta
	velocity.x = horizontal_speed
	if not is_on_floor():
		velocity.y += gravity * delta

	if ray_cast_front.is_colliding() and turn_cooldown <= 0:
		orientar_personaje(-1)
		super._turn()

	if ray_cast_back.is_colliding() and turn_cooldown <= 0:
		orientar_personaje(-1)
		super._turn()

	if ray_cast_back.is_colliding() and ray_cast_front.is_colliding() and not muerto:
		horizontal_speed = 0

	var _previous_position = position
	move_and_slide()

func die_by_block():
	hit()

func call_child_active():
	pass

func big_hit(direction):
	turn_off()
	for part in body_parts:
		var global_pos = part.global_position    
		part.global_position = global_pos 
		part.disarm(direction)      

func hit():
	turn_off()
	for part in body_parts:
		var global_pos = part.global_position    
		part.global_position = global_pos 
		part.disarm(0)      

func turn_off():
	sound.stream = load("res://scenes/characters/Enemies/Dry bones/GUESS_SE_O_KRN_Crash.wav")
	sound.play()
	$AnimationPlayer.play("RESET")
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("disabled", true)
	muerto = true
	$Timer.start()

func regroup():
	sound.stream = load("res://scenes/characters/Enemies/Dry bones/GUESS_SE_O_KRN_Reborn.wav")
	sound.play()
	var tween = create_tween()
	for part in body_parts:
		part.collision.set_deferred("disabled", true)
		part.rearm(original_positions[part])
		#tween.tween_property(part, "rotation", 0, 0.2)
		#tween.tween_property(part, "position", original_positions[part], 0.2)
	$Timer2.start()

func _on_timer_timeout() -> void:
	for part in body_parts:
		part.prepare_rearm()
	regroup()

func _on_timer_2_timeout() -> void:
	for part in body_parts:
		part.rearmed()
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D.set_deferred ("monitoring", true)
	$Area2D.set_deferred("monitorable", true)
	$AnimationPlayer.play("walking")
	muerto = false

func orientar_personaje(direccion: int):
	scale.x = direccion
