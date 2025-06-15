extends Bullet

var rainbow_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")  # 🔥 Inicia la animación
	gravity_scale = 0

	
func on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_timer_timeout() -> void:
	z_index = 2

func die():
	super.die()
