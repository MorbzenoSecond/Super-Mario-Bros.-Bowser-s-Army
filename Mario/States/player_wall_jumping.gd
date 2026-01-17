extends State
class_name PlayerWallJumping
var can_cut_off:= false
func Enter() -> void:
	player.get_current_sprite().animation = "jump"
	can_cut_off = false
	$Timer.start(0.2)
	if player.get_current_sprite().flip_h:
		player.get_current_sprite().flip_h = true
	else:
		player.get_current_sprite().flip_h = false

func Physics_Update(delta: float) -> void:
	var player = owner
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF:
		player.velocity.y = player.JUMP_CUTOFF
	if  player.front.is_colliding() and can_cut_off:
		Transitioned.emit(self, "PlayerInWall")
	if Input.is_action_just_pressed("space"):
		Transitioned.emit(self, "PlayerAirSpin")
	if Input.is_action_just_pressed("ui_down") and !player.down.is_colliding():
		Transitioned.emit(self, "PlayerPound")
	if player.is_on_floor():
		if player.velocity.x == 0:
			Transitioned.emit(self, "PlayerIdle")
		Transitioned.emit(self, "PlayerWalk")
	if Input.is_action_just_released("ui_accept") and player.velocity.y < player.JUMP_CUTOFF and can_cut_off:
		player.velocity.y = player.JUMP_CUTOFF +20
	if Input.is_action_just_pressed("ui_up") and player.in_fence:
		Transitioned.emit(self, "PlayerInFence")

func _on_timer_timeout() -> void:
	can_cut_off = true
