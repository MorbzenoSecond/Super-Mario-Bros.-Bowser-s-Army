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

func _on_top_area_area_exited(area: Area2D) -> void:
	super.left_top()
	

func _on_timer_2_timeout() -> void:
	$AnimatedSprite2D.play("throw_away")
	set_collision_layer_value(3, false)
	$Area2D.set_collision_layer_value(1, false)
	await get_tree().create_timer(0.5).timeout  # Tiempo de invulnerabilidad
	set_collision_layer_value(3, true)
	$Area2D.set_collision_layer_value(1, true)
