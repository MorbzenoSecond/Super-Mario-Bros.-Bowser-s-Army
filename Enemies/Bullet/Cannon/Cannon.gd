extends RigidBody2D

@export var bullet: PackedScene
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_shoot:= true

func active():
	$AnimatedSprite2D.visible = true
	$CollisionPolygon2D.set_deferred("disabled", false)

	$Timer.start()

func inactive():
	$AnimatedSprite2D.visible = false
	$CollisionPolygon2D.set_deferred("disabled", true)

	$Timer.stop()

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D/AnimatedSprite2D.animation = "default"
	#inactive()
func shoot():
	if not can_shoot:
		return 
	can_shoot= false
	$AnimatedSprite2D.play("shoot")
	$AnimatedSprite2D/AnimatedSprite2D.play("shoot")
	$AnimatedSprite2D/AnimatedSprite2D.z_index = -2
	var mob = bullet.instantiate()
	mob.z_index = -1 
	var mob_spawn_location = $Path2D/PathFollow2D

	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2
	mob.rotation = direction

	var velocity = Vector2(200, 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	mob.add_to_group("mobs")  # ✅ Para que se elimine correctamente en game_over()
	add_child(mob)


#func _process(delta):
	#var mouse_pos = get_global_mouse_position()

func _on_animated_sprite_2d_animation_finished() -> void:
	print("se detuvi")
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D/AnimatedSprite2D.play("default")

func _on_timer_timeout() -> void:
	can_shoot = true
	shoot()
