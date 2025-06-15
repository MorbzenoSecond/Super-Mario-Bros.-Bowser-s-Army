extends AnimatedSprite2D

func _on_animation_finished() -> void:
	print("deberia irse")
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
