extends Bullet

func _ready():
	$AnimatedSprite2D.play("default")  # 🔥 Inicia la animación
	gravity_scale = 0

func _on_timer_timeout() -> void:
	z_index = 2

func die():
	super.hit()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_timer_2_timeout() -> void:
	queue_free()
