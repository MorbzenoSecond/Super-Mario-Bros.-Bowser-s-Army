extends Node2D


func setup(global_position_new: Vector2) -> void:
	global_position = global_position_new
	$dust.restart()

func _on_dust_finished() -> void:
	queue_free()
