extends Node2D

func _ready() -> void:
	for part in $"brick parts".get_children():
		part.disarm()   
		part.mass = 1
		part.physics_material_override.bounce= 0.5

func setup(destruction_texture: Texture2D, global_position_new: Vector2) -> void:
	global_position = global_position_new

	$dust.restart()
	$bricks.restart()

func _on_timer_timeout() -> void:
	queue_free()
