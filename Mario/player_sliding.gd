extends State
class_name PlayerSliding
var speed_factor
var rotation = 0
func Enter() -> void:
	player.get_current_sprite().play("pound_fall")
	player.sliding = true

func Physics_Update(delta: float) -> void:
	if player.get_floor_normal().x < 0:
		speed_factor = clamp(abs(player.velocity.x) / player.RUN_MAX_SPEED, 0, 5)
		player.get_current_sprite().speed_scale = speed_factor
		if rotation != -45:
			rotation -= 15
		player.get_current_sprite().rotation = deg_to_rad(rotation)
		player.velocity.x = move_toward(player.velocity.x, -1 * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
	elif player.get_floor_normal().x > 0:
		speed_factor = clamp(abs(player.velocity.x) / player.RUN_MAX_SPEED, 0, 5)
		player.get_current_sprite().speed_scale = speed_factor
		if rotation != 45:
			rotation += 15
		player.get_current_sprite().rotation = deg_to_rad(rotation)
		player.velocity.x = move_toward(player.velocity.x, 1 * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
	elif player.get_floor_normal().x == 0 and player.is_on_floor():
		player.get_current_sprite().rotation = deg_to_rad(0.0)
		player.velocity.x = move_toward(player.velocity.x, -1 * 0, player.ACCELERATION * delta)
	if player.velocity.x == 0 and player.get_floor_normal().x == 0:
		Transitioned.emit(self, "PlayerIdle")

func Exit():
	player.sliding = false
