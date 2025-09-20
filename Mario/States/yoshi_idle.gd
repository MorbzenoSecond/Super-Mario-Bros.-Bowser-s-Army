extends State
class_name YoshiIdle


func Enter() -> void:
	player.get_current_sprite().play("riding_yoshi_idle")
	player.in_yoshi = true

func Physics_Update(delta: float) -> void:
	var input := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("enter"):
		Transitioned.emit(self, "PlayerStare")
	if Input.is_action_just_pressed("ui_down"):
		Transitioned.emit(self, "PlayerDuckEnter")
	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerSpin")
	if input != 0:
		Transitioned.emit(self, "YoshiWalk")
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")
