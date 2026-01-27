extends RigidBody2D
class_name Bullet
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
var muerto : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = -1

func hit():
	muerto = true
	gravity_scale = 0.1
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	$Area2D.set_collision_layer_value(1, false)
	$Area2D.set_collision_mask_value(1, false)
	set_collision_mask_value(1, false)
	
func top():
	animated_sprite_2d.play("On_top")
	$Timer2.start()
	gravity_scale = 0.01

func left_top():
	if !animated_sprite_2d.animation == "throw_away":
		animated_sprite_2d.play("default")
	$Timer.stop()
	gravity_scale = 0
