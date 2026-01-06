extends State
class_name BombPrepareExplosion

func Enter():
	player.velocity = Vector2(0,0)
	player.animated_sprite_2d.speed_scale = 1.0
	player.animated_sprite_2d.play("prepare")
# Called when the node enters the scene tree for the first time.
func Physics_Update(delta : float):
	player.update_shader()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
