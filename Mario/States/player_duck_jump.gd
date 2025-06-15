extends State
class_name PlayerDuckJump

func Enter() -> void:
	player.get_current_sprite().animation = "duck_jump"

func Physics_Update(delta: float) -> void:
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF:
		player.velocity.y = player.JUMP_CUTOFF
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.DUCK_MAX_SPEED, player.ACCELERATION * delta)
	if player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self, "PlayerDuck")
