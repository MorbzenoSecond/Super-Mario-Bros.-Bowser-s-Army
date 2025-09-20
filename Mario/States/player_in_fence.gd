extends State
class_name PlayerInFence

func Enter() -> void: 
	player.using_fence = true
	player.get_current_sprite().play("in_fence")
	player.velocity = Vector2(0,0)
	player.GRAVITY = 0
	player.snap = 0
	player.position.y -= 5
	player.get_current_sprite().speed_scale = 2
	#player.z_index = -1000
func Physics_Update(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerJump")
		return
	if player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")

	if !player.in_fence:
		Transitioned.emit(self, "PlayerIdle")

	elif Input.is_action_pressed("ui_down"):
		player.get_current_sprite().play_backwards("up_down_fence")
		player.position.y += 2
		if Input.is_action_pressed("ui_left"):
			player.position.x -= 2
		if Input.is_action_pressed("ui_right"):
			player.position.x += 2
		return

	elif Input.is_action_pressed("ui_up"):
		player.get_current_sprite().play("up_down_fence")
		player.position.y -= 2
		if Input.is_action_pressed("ui_left"):
			player.position.x -= 2
		if Input.is_action_pressed("ui_right"):
			player.position.x += 2
		return

	elif Input.is_action_pressed("ui_left"):
		player.get_current_sprite().play("left_right_fence")
		player.get_current_sprite().flip_h = true
		player.position.x -= 2
		return

	elif Input.is_action_pressed("ui_right"):
		player.get_current_sprite().play("left_right_fence")
		player.position.x += 2
		player.get_current_sprite().flip_h = false
		return

	else:
		player.get_current_sprite().play("in_fence")


func Exit() -> void:
	#player.z_index = 1000
	player.using_fence = false
	player.snap = 32
	player.GRAVITY = 900.0
