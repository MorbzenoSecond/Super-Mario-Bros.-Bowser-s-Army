extends State
class_name PlayerInWall
var lateralJump = -135

func Enter() -> void: 
	player.get_current_sprite().play("mario_in_wall")
	player.velocity.y = 0
	player.GRAVITY = 10.0

func Physics_Update(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")
	if !player.front.is_colliding():
		Transitioned.emit(self, "PlayerIdle")

	if Input.is_action_just_pressed("space"):
		player.velocity.y = player.JUMP_FORCE
		player.front.target_position.x = player.front.target_position.x  * -1
		player.behind.target_position.x = player.behind.target_position.x  * -1
		Transitioned.emit(self, "PlayerWallJumping")
		if player.get_current_sprite().flip_h:
			player.velocity.x = -lateralJump
		elif !player.get_current_sprite().flip_h:
			player.velocity.x = lateralJump

	if player.get_current_sprite().flip_h and player.front.target_position.x < 0:
		player.get_current_sprite().flip_h = true
	if player.get_current_sprite().flip_h and player.front.target_position.x > 0:
		player.get_current_sprite().flip_h = false
	if !player.get_current_sprite().flip_h and player.front.target_position.x < 0:
		player.get_current_sprite().flip_h = true
	if !player.get_current_sprite().flip_h and player.front.target_position.x > 0:
		player.get_current_sprite().flip_h = false



func Exit() -> void:
	player.GRAVITY = GameState.global_gravity
