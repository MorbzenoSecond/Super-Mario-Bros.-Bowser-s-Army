extends State
class_name PrepareExplosionLegLess

# Called when the node enters the scene tree for the first time.
func Enter():
	player.animated_sprite_2d.play("leg_less")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta : float):
	player.update_shader()
	if player.is_on_floor():
		player.velocity = Vector2(0,0)
