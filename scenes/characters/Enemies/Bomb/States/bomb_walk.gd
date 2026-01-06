extends State
class_name BombWalk

func Physics_Update(delta : float):
	player.velocity.x = player.horizontal_speed
	
	if player.ray_cast_back.is_colliding() and player.ray_cast_front.is_colliding() and player.turn_cooldown <=0 and not player.muerto:
		player.horizontal_speed = 0

	if player.ray_cast_front.is_colliding() and player.turn_cooldown <= 0:
		player.horizontal_speed *= -1
		player.animated_sprite_2d.flip_h = -player.horizontal_speed < 0
		player.player.scale.x = -sign(player.horizontal_speed)
		player.turn_cooldown = player.TURN_DELAY

	if player.ray_cast_back.is_colliding() and player.turn_cooldown <= 0: 
		player.horizontal_speed *= -1
		player.animated_sprite_2d.flip_h = -player.horizontal_speed < 0
		player.player.scale.x = -sign(player.horizontal_speed)
		player.turn_cooldown = player.TURN_DELAY
	
	if player.player.is_colliding():
		var collider = player.player.get_collider()
		if collider and collider.is_in_group("Player") and player.is_on_floor():
			player.target_position = collider.global_position
			Transitioned.emit(self, "BombSurprised")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Exit():
	player.velocity.x = 0
	player.horizontal_speed = 0
