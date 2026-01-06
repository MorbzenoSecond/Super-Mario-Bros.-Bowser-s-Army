extends State
class_name ArmyGoombaSprint

func Enter():
	player.SPEED_VAL = 140
	$Timer.start()
	$"../../../AnimationPlayer".play("run")
	if player.mario:
		if player.global_position.x < player.mario.global_position.x:
			player.velocity.x = player.SPEED_VAL
		else:
			player.velocity.x = -player.SPEED_VAL


func _on_timer_timeout() -> void:
	Transitioned.emit(self, "ArmyGoombaIdle")
