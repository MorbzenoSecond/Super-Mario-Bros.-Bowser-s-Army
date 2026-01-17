extends State
class_name PlayerJump

func Enter() -> void:
	player.get_current_sprite().play("jump") 
	player.actual_animation = "jump"

func Physics_Update(delta: float) -> void:
	var player = owner
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("enter"):
		player.velocity.x = move_toward(player.velocity.x, direction * player.RUN_MAX_SPEED, player.JUMP_ACCELERATION * delta)
	player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)
	if Input.is_action_just_pressed("ui_right") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("ui_left") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("ui_down") and !player.down.is_colliding():
		Transitioned.emit(self, "PlayerPound")
	if Input.is_action_just_pressed("space") :
		Transitioned.emit(self, "PlayerAirSpin")
	if player.velocity.y > 50:
		Transitioned.emit(self, "PlayerFall")
		return
	if player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF:
		player.velocity.y = player.JUMP_CUTOFF
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")
