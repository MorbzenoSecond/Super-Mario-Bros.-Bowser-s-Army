extends State
class_name KoopaShellSpining

var player_mode = "BIG"
var shell_speed = 400
var turn := true
@onready var timer = $Timer
func Enter():
	var character = owner
	character.particles.emitting = true
	character.animated_sprite_2d.play("green_spining_shell")

func Physics_Update(delta: float) -> void:
	
	var character = owner
	character.turn_cooldown -= delta

	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta  
		character.particles.emitting = false
	else:
		character.particles.emitting = true
	character.velocity.x = -character.direction * shell_speed

	# Manejo de colisión con bloque
	if character.ray_cast_front.is_colliding():
		var collider = character.ray_cast_front.get_collider()

		# Si colisiona con un bloque, activarlo
		if character.turn_cooldown <= 0:
			if collider is Block:
				collider.bump(Player.PlayerMode.FIRE)
			elif collider is Player:
				return
			elif collider is Enemy:
				for body in character.area2d.get_overlapping_bodies():
					if body is Enemy and body != character:
						body.die_by_block()
				return  # no giramos

			# Gira
			character.direction *= -1
			character.ray_cast_front.scale.x = -sign(character.horizontal_speed)
			character.ray_cast_back.scale.x = -sign(character.horizontal_speed)
			character.animated_sprite_2d.flip_h = -character.horizontal_speed < 0
			character.turn_cooldown = character.TURN_DELAY

	if character.ray_cast_back.is_colliding():
		var collider = character.ray_cast_back.get_collider()

		# Si colisiona con un bloque, activarlo
		if character.turn_cooldown <= 0:
			if collider is Block:
				collider.bump(Player.PlayerMode.FIRE, "up")
			elif collider is Player:
				return
			elif collider is Enemy:
				for body in character.area2d.get_overlapping_bodies():
					if body is Enemy and body != character:
						body.die_by_block()
				return  # no giramos

			# Gira
			character.direction *= -1
			character.ray_cast_front.scale.x = -sign(character.horizontal_speed)
			character.ray_cast_back.scale.x = -sign(character.horizontal_speed)
			character.animated_sprite_2d.flip_h = -character.horizontal_speed < 0
			character.turn_cooldown = character.TURN_DELAY

	if !character.is_spining:
		character.velocity.x = 0
		character.particles.emitting = false
		Transitioned.emit(self, "KoopaShell")
