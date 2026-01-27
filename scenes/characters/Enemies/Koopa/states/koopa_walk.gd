extends State
class_name KoopaWalk

func Physics_Update(delta : float):
	var character = owner  # o get_parent()
	character.turn_cooldown -= delta
	if character.red == true:
		character.animated_sprite_2d.play("red_walk")
	else:
		character.animated_sprite_2d.play("green_walk")
	character.velocity.x = character.horizontal_speed
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta

	# Detectar colisión frontal para girar
	if character.ray_cast_front.is_colliding():
		character.horizontal_speed *= -1
		character.ray_cast_front.scale.x = -sign(character.horizontal_speed)
		character.floor.position.x = -character.floor.position.x 
		character.ray_cast_back.scale.x = -sign(character.horizontal_speed)
		character.animated_sprite_2d.flip_h = -character.horizontal_speed < 0 
		character.turn_cooldown = character.TURN_DELAY

	#if character.ray_cast_back.is_colliding() and character.ray_cast_front.is_colliding() and not character.muerto:
		#character.animated_sprite_2d.play("Trap")
		#character.horizontal_speed = 0

	if character.shell:
		print("koopa shell")
		character.velocity.x = 0
		#character.animation.play("shell_static")
		Transitioned.emit(self, "KoopaShell")
