extends State
class_name BombAttackRun

func Enter():
	player.animated_sprite_2d.speed_scale = 3.0
	player.animated_sprite_2d.play("angry_run")
	player.prepare()


func Physics_Update(delta : float):
	var direction = (player.target_position - player.global_position).normalized()
	player.velocity.x = direction.x * player.attack_spped
	player.update_shader()
	if player.velocity.x > -10 and player.velocity.x < 10:
		Transitioned.emit(self, "BombPrepareExplosion")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Exit():
	player.velocity.x = 0
	player.horizontal_speed = 0
