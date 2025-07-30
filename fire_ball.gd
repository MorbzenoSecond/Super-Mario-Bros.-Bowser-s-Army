extends Area2D

class_name Fireball
# Called when the node enters the scene tree for the first time.
@export var horizontal_speed = 3
@export var bounce_force = 250
var max_bounces = 4
var bounces = 0
@onready var down = $Down
@onready var trail = $CPUParticles2D
@onready var front = $Front
@onready var animared = $AnimatedSprite2D
@onready var animated = $AnimationPlayer
var velocity := Vector2.ZERO
var bounce = true
var bounce_front = true
var has_hit = false

func setup(direction, player_speed):
	front.scale.x = -sign(direction)
	velocity.x = horizontal_speed * direction + player_speed * -0.75

# Called every frme. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= velocity * delta
	
	velocity.y +=gravity*delta

	if bounces == max_bounces:
		_fire_ball_out()
	
	if down.is_colliding() and bounce:

		bounces += 1
		velocity.y = bounce_force
		bounce = false 
		await get_tree().create_timer(0.1).timeout
		bounce = true
	if front.is_colliding() and bounce_front:
		velocity *= -1
		front.scale.x *=-1
		bounce_front = false 
		await get_tree().create_timer(0.1).timeout  
		bounce_front = true

func _fire_ball_out():
	trail.emitting = false
	animared.visible = false
	$Timer.start()
	
func _on_body_entered(body: Node2D) -> void:
	if !has_hit:
		if body.is_in_group("Enemies"):
			_fire_ball_out()
			body.hit()
		if body.is_in_group("Bombs"):
			queue_free()
			body.explote()
		has_hit = true

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if !has_hit:
		if area.is_in_group("Piranna"):
			_fire_ball_out()
			area.die()
		has_hit = true
