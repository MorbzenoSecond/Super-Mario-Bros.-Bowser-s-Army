extends State
class_name PlayerWalk

func Enter() -> void:
	player.get_current_sprite().play("walk")
	player.actual_animation = "walk"
	$Timer.start()

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
		$Timer.stop()

	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.get_current_sprite().speed_scale = 1
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerJump")
		$Timer.stop()
	if player.is_on_floor() and direction != 0 and sign(direction) != sign(player.velocity.x) :
		player.get_current_sprite().speed_scale = 1
		player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)
		$Timer.stop()
	if player.is_on_floor() and direction != 0 and abs(player.velocity.x) == 400:
		player.get_current_sprite().speed_scale = 1
		Transitioned.emit(self, "PlayerRun")
		$Timer.stop()
	if Input.is_action_just_pressed("ui_down"):
		Transitioned.emit(self, "PlayerDuckEnter")
	if  !player.is_on_floor() and player.velocity.y > 200:
		print("fall")
		Transitioned.emit(self, "PlayerFall")

	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")
	
func Exit():
	player.get_current_sprite().speed_scale = 1
