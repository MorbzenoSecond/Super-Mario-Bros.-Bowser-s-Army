extends State
class_name PlayerSpin

func Enter() -> void:
	player.get_current_sprite().play("jump") 
	yoshi()

func Physics_Update(delta: float) -> void:
	var player = owner
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("enter"):
		player.velocity.x = move_toward(player.velocity.x, direction * player.RUN_MAX_SPEED, player.JUMP_ACCELERATION * delta)
	player.velocity.x = move_toward(player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta)
	if Input.is_action_just_pressed("ui_right") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("ui_left") and player.front.is_colliding():
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("space") and !player.down.is_colliding():
		Transitioned.emit(self, "PlayerPound")
	if player.velocity.y > 50:
		Transitioned.emit(self, "PlayerFall")
		return
	if player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF:
		player.velocity.y = player.JUMP_CUTOFF
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")

func yoshi():
	var yoshi = player.yoshi.instantiate()

	var level = player.get_parent().get_node("Levels").get_child(0)
	level.add_child(yoshi)

	yoshi.global_position = player.global_position + Vector2(0, 20)
	
	yoshi.setup(player.get_current_sprite().flip_h)
	
