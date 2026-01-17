extends State
class_name ArmyGoombaIdle

func Enter():
	player.velocity.x = 0
	$Timer.start()
	$"../../../AnimationPlayer".play("idle")

func Physics_Update(_delta : float):
	pass
	#if player.mario:
		#if player.global_position.x < player.mario.global_position.x:
			#player.velocity.x = player.SPEED_VAL
		#else:
			#player.velocity.x = -player.SPEED_VAL

#func Exit():
	#if player.scale.y > 0:
		#if player.mario_is_left():
			#player.orientar_personaje(-1)
	#else:
		#if !player.mario_is_left():
			#player.orientar_personaje(-1)

func _on_timer_timeout() -> void:
	if player.scale.y > 0:
		if player.mario_is_left():
			Transitioned.emit(self, "ArmyGoombaTurn")
			return
	else:
		if !player.mario_is_left():
			Transitioned.emit(self, "ArmyGoombaTurn")
			return
	if player.cannon.heating >= 70.0 and player.cannon.heating <= 100.0:
		Transitioned.emit(self, "ArmyGoombaFreeFire")
		return
	
	if abs(player.global_position.x - player.mario.global_position.x) <= 500:
		player.cannon.spining = true
		Transitioned.emit(self, "ArmyGoombaPrepareJump")
	else:
		Transitioned.emit(self, "ArmyGoombaSprint")

func Exit():
	player.dust.amount = 15
	player.dust.emission_rect_extents.x = 3
	player.dust.lifetime = 0.6
