extends State
class_name PlayerDuckExit
var has_entered = false
func Enter():
	player.get_current_sprite().play("duck_enter")
	$Timer.start()

func Physics_Update(delta : float):
	var direction := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, direction * player.DUCK_MAX_SPEED, player.ACCELERATION * delta)
	if player.velocity.x < 0:
		player.get_current_sprite().flip_h = true
	if player.velocity.x > 0:
		player.get_current_sprite().flip_h = false
	
	if has_entered:
		if !Input.is_action_pressed("ui_down"):
			Transitioned.emit(self, "PlayerIdle")
	if !player.get_floor_normal().x == 0:
		Transitioned.emit(self, "PlayerSliding")
func _on_timer_timeout() -> void:
	has_entered = true
