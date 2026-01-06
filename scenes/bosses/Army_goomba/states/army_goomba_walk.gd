extends State
class_name ArmyGoombaWalk

func Enter():
	$Timer2.start()
	if !player.rotation_degrees >= 170:
		player.rotate_children(360)
	else: 
		player.rotate_children(-180)
	player.SPEED_VAL = 70
	$Timer.start()
	$"../../../AnimationPlayer".play("walk")
	if player.mario:
		if player.global_position.x < player.mario.global_position.x:
			player.velocity.x = player.SPEED_VAL
		else:
			player.velocity.x = -player.SPEED_VAL

func _on_timer_timeout() -> void:
	$Timer2.stop()
	player.cannon.spining = false
	Transitioned.emit(self, "ArmyGoombaIdle")

func _on_timer_2_timeout() -> void:
	player.cannon.shoot()
