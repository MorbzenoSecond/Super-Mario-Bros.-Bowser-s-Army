extends RigidBody2D

@onready var cannon = $cannon
@onready var cannon_mouth = $cannon/cannon_mouth

@export var bullet: PackedScene
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_shoot:= true

func active():
	cannon_mouth.visible = true
	$CollisionPolygon2D.set_deferred("disabled", false)

	$Timer.start()

func inactive():
	$cannon/cannon_mouth.visible = false
	cannon_mouth.set_deferred("disabled", true)

	$Timer.stop()

func _ready() -> void:
	cannon_mouth.play("default")
	cannon.animation = "default"
	#inactive()
func shoot():
	if not can_shoot:
		return 
	can_shoot= false
	cannon_mouth.play("shoot")
	cannon.play("shoot")
	var mob = bullet.instantiate()
	var mob_spawn_location = $Path2D/PathFollow2D

	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2
	mob.rotation = direction

	var velocity = Vector2(80, 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	mob.add_to_group("mobs")  # ✅ Para que se elimine correctamente en game_over()
	$Objects.add_child(mob)


#func _process(delta):
	#var mouse_pos = get_global_mouse_position()

func _on_animated_sprite_2d_animation_finished() -> void:
	cannon_mouth.play("default")
	cannon.play("default")

func _on_timer_timeout() -> void:
	can_shoot = true
	shoot()
