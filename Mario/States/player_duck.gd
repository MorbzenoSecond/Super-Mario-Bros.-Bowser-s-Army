extends State
class_name PlayerDuck

func Enter():
	player.get_current_sprite().play("duck")
	player.actual_animation = "duck"

func Physics_Update(delta : float):
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.DUCK_MAX_SPEED, (player.ACCELERATION + 200) * delta)
	if player.velocity.x < 0:
		player.get_current_sprite().flip_h = true
	if player.velocity.x > 0:
		player.get_current_sprite().flip_h = false
	if !player.get_floor_normal().x == 0:
		Transitioned.emit(self, "PlayerSliding")
	var input := Input.get_axis("ui_left", "ui_right")
	if !Input.is_action_pressed("ui_down"):
		Transitioned.emit(self, "PlayerDuckExit")
	if input != 0:
		Transitioned.emit(self, "PlayerDuckWalk")
	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerDuckJump")
