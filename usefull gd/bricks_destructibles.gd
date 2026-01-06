extends RigidBody2D

func disarm():
	linear_velocity.y = -240
	linear_velocity.x = randf_range(-40,40)
	gravity_scale = 1
	var tween = get_tree().create_tween()
	tween.tween_interval(2)
	tween.tween_property($Sprite2D, "modulate", Color("ffffff00"), 0.5)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
