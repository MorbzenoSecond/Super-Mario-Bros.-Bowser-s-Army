extends State
class_name PlayerRunJump

func Enter() -> void:
	player.get_current_sprite().play("run_jump")
	player.actual_animation = "run_jump"

func Physics_Update(delta: float) -> void:
	#$AudioStreamPlayer2D.play()
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF:
		player.velocity.y = player.JUMP_CUTOFF
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
	if Input.is_action_just_pressed("space") and !player.down.is_colliding():
		Transitioned.emit(self, "PlayerPound")
	if Input.is_action_just_pressed("ui_right") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("ui_left") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self, "PlayerRun")
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")
