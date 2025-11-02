extends State
class_name PlayerFriction

func Enter() -> void:
	player.get_current_sprite().play("friction")
	player.actual_animation = "idle"
	

func Physics_Update(delta: float) -> void:
	if player.velocity.x > 0:
		player.get_current_sprite().flip_h = true
	if player.velocity.x < 0:
		player.get_current_sprite().flip_h = false
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta +5)
	if player.velocity.x == 0:
		Transitioned.emit(self, "PlayerIdle")
		
	if player.velocity.x > 0 and Input.is_action_pressed("ui_right"):
		Transitioned.emit(self, "PlayerWalk")
		
	if player.velocity.x < 0 and Input.is_action_pressed("ui_left"):
		Transitioned.emit(self, "PlayerWalk")
		
	if player.is_on_floor() and Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		Transitioned.emit(self, "PlayerJump")
