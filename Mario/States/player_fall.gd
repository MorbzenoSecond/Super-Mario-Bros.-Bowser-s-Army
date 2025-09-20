extends State
class_name PlayerFall

func Enter() -> void:
	player.falling = true
	player.get_current_sprite().animation = "falling"

func Physics_Update(delta: float) -> void:
	var direction : = Input.get_axis("ui_left", "ui_right")
	if player.in_yoshi:
		Transitioned.emit(self, "YoshiIdle")
	if Input.is_action_pressed("enter"):
		player.velocity.x = move_toward(player.velocity.x, direction * player.RUN_MAX_SPEED, player.JUMP_ACCELERATION * delta)
	player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)
	if Input.is_action_just_pressed("space") and !player.down.is_colliding():
		Transitioned.emit(self, "PlayerPound")
	if Input.is_action_just_pressed("ui_right") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("ui_left") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if player.velocity.y < 0:
		Transitioned.emit(self, "PlayerJump")
	if player.velocity.y == 0 and player.is_on_floor() and player.velocity.x == 0:
		Transitioned.emit(self, "PlayerIdle")
	if player.velocity.y == 0 and player.is_on_floor() and player.velocity.x != 0:
		Transitioned.emit(self, "PlayerWalk")
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")

func Exit():
	player.falling = false
