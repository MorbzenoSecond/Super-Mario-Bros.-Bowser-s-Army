extends State
class_name PlayerFall

func Enter() -> void:
	player.get_current_sprite().animation = "falling"

func Physics_Update(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)
	if player.velocity.y < 0:
		Transitioned.emit(self, "PlayerJump")
	if player.velocity.y == 0 and player.is_on_floor() and player.velocity.x == 0:
		Transitioned.emit(self, "PlayerIdle")
	if player.velocity.y == 0 and player.is_on_floor() and player.velocity.x != 0:
		Transitioned.emit(self, "PlayerWalk")
	
