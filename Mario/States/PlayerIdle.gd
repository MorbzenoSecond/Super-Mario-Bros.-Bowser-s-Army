extends State
class_name PlayerIdle

func Enter():
	player.get_current_sprite().play("idle")
	player.actual_animation = "idle"
	player.GRAVITY = 900.0
	player.velocity.x = 0

func Physics_Update(_delta : float):
	var input := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("enter"):
		Transitioned.emit(self, "PlayerStare")
	if Input.is_action_just_pressed("ui_down"):
		Transitioned.emit(self, "PlayerDuckEnter")
	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerJump")
	if input != 0:
		Transitioned.emit(self, "PlayerWalk")
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")
