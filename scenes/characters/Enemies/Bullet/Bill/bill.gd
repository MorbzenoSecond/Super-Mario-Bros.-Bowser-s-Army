extends Bullet

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("default")
	gravity_scale = 0



func _physics_process(delta):
	if linear_velocity.length() > 0.1:
		rotation = linear_velocity.angle()

func _on_timer_timeout() -> void:
	z_index = 2

func die():
	super.hit()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_timer_2_timeout() -> void:
	queue_free()
