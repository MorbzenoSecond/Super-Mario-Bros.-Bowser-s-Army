extends State
class_name PlayerRun

func Enter() -> void:
	player.get_current_sprite().play("run")

func Physics_Update(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("enter"):
		var speed_factor = clamp(abs(player.velocity.x) / player.RUN_MAX_SPEED, 0, 5)
		player.get_current_sprite().speed_scale = speed_factor
		player.velocity.x = move_toward(player.velocity.x, direction * player.RUN_MAX_SPEED, player.ACCELERATION * delta)

	else:
		var speed_factor = clamp(abs(player.velocity.x) / player.MAX_SPEED, 0, 5)
		player.get_current_sprite().speed_scale = speed_factor
		player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)

	if player.velocity.x < 0:
		player.get_current_sprite().flip_h = true
	if player.velocity.x > 0:
		player.get_current_sprite().flip_h = false
	if player.velocity.x == 0:
		player.get_current_sprite().speed_scale = 1
		Transitioned.emit(self, "PlayerIdle")


	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.get_current_sprite().speed_scale = 1
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerRunJump")

	if player.is_on_floor() and direction != 0 and sign(direction) != sign(player.velocity.x) :
		player.get_current_sprite().speed_scale = 1
		Transitioned.emit(self, "PlayerFriction")

	if player.is_on_floor() and direction != 0 and abs(player.velocity.x) < 320:
		player.get_current_sprite().speed_scale = 1
		Transitioned.emit(self, "PlayerWalk")

	if Input.is_action_just_pressed("ui_down"):
		Transitioned.emit(self, "PlayerDuckEnter")
