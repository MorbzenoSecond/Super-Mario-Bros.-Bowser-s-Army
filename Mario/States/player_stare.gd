extends State
class_name PlayerStare

func Enter():
	player.get_current_sprite().play("stare")
	player.velocity.x = 0

func Physics_Update(_delta : float):
	var input := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_down"):
		Transitioned.emit(self, "PlayerDuckEnter")
	if Input.is_action_just_released("enter"):
		Transitioned.emit(self, "PlayerIdle")
	if input != 0:
		Transitioned.emit(self, "PlayerWalk")
	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerJump")
