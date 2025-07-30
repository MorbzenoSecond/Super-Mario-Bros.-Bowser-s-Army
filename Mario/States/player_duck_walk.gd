extends State
class_name PlayerDuckWalk

func Enter() -> void:
	player.get_current_sprite().play("walking_duck")

func Physics_Update(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.DUCK_MAX_SPEED, player.ACCELERATION * delta)
	if player.velocity.x < 0:
		player.get_current_sprite().flip_h = true
	if player.velocity.x > 0:
		player.get_current_sprite().flip_h = false
	if player.velocity.x == 0:
		Transitioned.emit(self, "PlayerDuck")
	if !player.get_floor_normal().x == 0:
		Transitioned.emit(self, "PlayerSliding")


	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerDuckJump")

	if Input.is_action_just_released("ui_down"):
		Transitioned.emit(self, "PlayerIdle")
