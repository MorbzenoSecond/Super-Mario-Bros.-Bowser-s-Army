extends CharacterBody2D
class_name Enemy

@export var horizontal_speed := -30
@export var gravity := 300.0
@onready var ray_cast_front = $Front
@onready var ray_cast_back = $Back
@onready var death = $die
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var area_collision = $Area2D/CollisionShape2D
var initial_position: Vector2
var muerto : bool = false
var initial_direction:=-1


var turn_cooldown := 0.0
const TURN_DELAY := 0.2

func _ready() -> void:
	initial_position = global_position
	animated_sprite_2d.play("walk")
	initial_direction = sign(horizontal_speed)
	$CollisionShape2D.disabled = false
	$Area2D.monitorable = true
	$Area2D.monitoring = true
	$AnimatedSprite2D.visible = true
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func hit():
	call_child_ready()

func call_child_ready():
	pass

func die_by_block():
	var death_tween = get_tree().create_tween()
	death.play()
	muerto = true
	z_index = 10
	horizontal_speed = 0
	animated_sprite_2d.play("death_by_brick")

	# Primera rotación suave hacia arriba y un poco a un lado
	death_tween.tween_property(self, "rotation_degrees", rotation_degrees + 45, 0.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	death_tween.parallel().tween_property(self, "position", position + Vector2(50, -50), 0.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	# Segunda rotación y caída suave
	death_tween.chain().tween_property(self, "rotation_degrees", rotation_degrees + 750, 3.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	death_tween.parallel().tween_property(self, "position", position + Vector2(500, 1500), 3.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
		
func active():
	rotation_degrees = 0
	call_child_active()
	gravity = 300
	muerto = false
	$AnimatedSprite2D.visible = true
	super.set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D.set_deferred("monitoring", true)
	$Area2D.set_deferred("monitorable", true)
	horizontal_speed = -60
	animated_sprite_2d.flip_h = -horizontal_speed < 0
	ray_cast_front.scale.x = -sign(horizontal_speed)
	ray_cast_back.scale.x = -sign(horizontal_speed)

func call_child_active():
	pass

func inactive():
	$AnimatedSprite2D.visible = false
	super.set_physics_process(false)
	global_position = initial_position
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)
