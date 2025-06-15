extends State
class_name PlayerJump

func Enter() -> void:
	player.get_current_sprite().animation = "jump"

func Physics_Update(delta: float) -> void:
	var player = owner
	if player.right_outer.is_colliding() and !player.right_inner.is_colliding() and !player.left_inner.is_colliding() and !player.left_outer.is_colliding() and !player.right.is_colliding():
		player.global_position.x -= 10
	if player.left_outer.is_colliding() and !player.right_inner.is_colliding() and !player.right_outer.is_colliding() and !player.left_inner.is_colliding() and !player.left.is_colliding():
		player.global_position.x += 10
	#if player.not_right.is_colliding() and !player.down_right.is_colliding():
		#print("entro a la condicion")
		#player.global_position.y -=10
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF:
		player.velocity.y = player.JUMP_CUTOFF
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)
	if player.velocity.y > 50:
		Transitioned.emit(self, "PlayerFall")
	if player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")
